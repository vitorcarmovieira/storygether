//
//  TimeLineTableViewController.swift
//  StoryGether
//
//  Created by Vitor on 5/25/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse
import CoreData

class TimeLineTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var timelineData:[PFObject]?
    var searchBar:UISearchBar!
    var filtered:[PFObject]?
    var users:[PFObject]?
    var searchActive: Bool = false
    var fetchedResultsController: NSFetchedResultsController!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchedResultsController = Historias.fetchedResultsController("createdAt", ascending: true)
        fetchedResultsController.delegate = self
        
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.bounds.width-100, 20))
        self.searchBar.delegate = self
        
        let rightButtonNavBar = UIBarButtonItem(image: UIImage(named: "icon_search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButton")
        self.navigationItem.rightBarButtonItem = rightButtonNavBar
        
        activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        
        Model.fetchParseObjectsWithClassName("Historia", completionHandler: {
            array in
            if let data = array{
                self.timelineData = data
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.tableView.reloadData()
            }
        })
        
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
        
        self.navigationItem.title = "StoryGether"
        let rightButtonNavBar = UIBarButtonItem(image: UIImage(named: "icon_search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButton")
        self.navigationItem.rightBarButtonItem = rightButtonNavBar
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func update(){
        
        print("updating...\n")
        updateData()
        self.refreshControl?.endRefreshing()
    }
    
    func updateData(){
        
//        var findTimelineData:PFQuery = PFQuery(className: "Historias")
//        let date = self.timelineData.lastObject?.createdAt
//        findTimelineData.whereKey("createdAt", greaterThan: date!!)
//        findTimelineData.orderByDescending("createdAt")
//        
//        findTimelineData.findObjectsInBackgroundWithBlock{
//            (objects:[AnyObject]?, error:NSError?)->Void in
//            
//            if error == nil{
//                if let historias = objects as? [PFObject] {
//                    
//                    for historia in historias {
//                        println("\(historia)")
//                        self.timelineData.addObject(historia)
//                    }
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.removeFromSuperview()
//                    self.tableView.reloadData()
//                }
//            }
//        }
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if (self.searchActive) {
            
            return (self.filtered?.count)!
        }
        if let count = self.timelineData?.count{
            return count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (self.searchActive){
            let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! UserCell
            if let user = self.filtered?[indexPath.row]{
                let profile:NSDictionary = user.valueForKey("profile")! as! NSDictionary
                cell.nomeUser.text = profile.valueForKey("name") as? String
                cell.imagemUser.setImageAssync(profile["urlFoto"] as? String)
                cell.parseObjects = user
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoriaTableViewCell
        
        cell.parseObject = self.timelineData?[indexPath.row]
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
            
            let historia: PFObject = self.timelineData![index.row]
            historiaTVC.Historia = historia
    }
    
    

}
