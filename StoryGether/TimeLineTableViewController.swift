//
//  TimeLineTableViewController.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class TimeLineTableViewController: UITableViewController {

    typealias dic = [String : String]
    
    var timelineData = [dic]()
    var searchBar:UISearchBar!
    var filtered:[PFObject]?
    var users:[PFObject]?
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.bounds.width-100, 20))
        self.searchBar.delegate = self
        
        let rightButtonNavBar = UIBarButtonItem(image: UIImage(named: "icon_search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButton")
        self.navigationItem.rightBarButtonItem = rightButtonNavBar
        
//        let model = Model.sharedStore
//        
//        model.fetchFromLocalWithClassName("Historias", completion: {
//            objects in
//            self.timelineData = objects
//            self.tableView.reloadData()
//        })
//        
//        model.fetchParseObjectsWithClassName(.Historia, completion: {
//            objects in
//            self.timelineData = objects
//            self.tableView.reloadData()
//        })
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.rowHeight=UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight=130
        self.tableView.layoutIfNeeded()
    }
    
    func searchButton(){
        
        self.fetchUsers()
        self.navigationItem.title = nil
        let leftButtonNavBar = UIBarButtonItem(customView: self.searchBar)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButton")
        self.navigationItem.setLeftBarButtonItem(leftButtonNavBar, animated: true)
        self.navigationItem.setRightBarButtonItem(cancelButton, animated: true)
    }
    
    func cancelButton(){
        
        self.searchActive = false
        self.tableView.reloadData()
        self.navigationItem.title = "storygether"
        let rightButtonNavBar = UIBarButtonItem(image: UIImage(named: "icon_search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButton")
        self.navigationItem.rightBarButtonItem = rightButtonNavBar
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func update(){
        
        print("updating...\n")
        self.refreshControl?.endRefreshing()
    }
    
    func fetchUsers(){
        
        let className = PFUser.currentUser()?.parseClassName
        var users:PFQuery = PFQuery(className: className!)
        users.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            
            if error == nil{
                if let users = objects as? [PFObject] {
                    self.users = []
                    self.users = users
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (self.searchActive) {
            
            return (self.filtered?.count)!
        }else{
            
            return Model.sharedStore.getAllItems().count
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (self.searchActive){
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
            if let user = self.filtered?[indexPath.row]{
                cell.parseObjects = user
                cell.awakeFromNib()
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoriaTableViewCell
        
        let historia = Model.sharedStore.getAllItems()[indexPath.row]
        
        cell.historia = historia
        cell.awakeFromNib()
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.searchActive{
            return nil
        }
        
        let header = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! TimeLineHeaderCell
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.searchActive{
            return 0
        }
        
        let height = 40.0 as CGFloat
        
        return height
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
        var historiaTVC = segue.destinationViewController as! TrechosViewController
        let index: NSIndexPath = self.tableView.indexPathForSelectedRow()!
        
        let id = self.timelineData[index.row]["objectId"]
        let titulo = self.timelineData[index.row]["titulo"]
        historiaTVC.id = id!
        historiaTVC.titulo = titulo!
    }

}
