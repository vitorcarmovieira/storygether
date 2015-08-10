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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchedResultsController = Historias.fetchedResultsController("createdAt", ascending: true)
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.bounds.width-100, 20))
        self.searchBar.delegate = self
        
        let rightButtonNavBar = UIBarButtonItem(image: UIImage(named: "icon_search"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchButton")
        self.navigationItem.rightBarButtonItem = rightButtonNavBar
        
        Model.update()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        
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
        Model.update()
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
            let sec = self.fetchedResultsController.sections as! [NSFetchedResultsSectionInfo]
            
            return sec[section].numberOfObjects
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
        
        let historia = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Historias
        
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
            
            let historia = self.fetchedResultsController.objectAtIndexPath(index) as! Historias
            historiaTVC.Historia = historia
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
            
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            print("Historia inserido")
            
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Top)
            print("Historia deletado")
        
        case .Update:
            let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as! HistoriaTableViewCell
            cell.numEscritores.text = (anObject as? Historias)?.trechos?.count.description
            println("Historia atualizado")
            
        default:
            print("Tipo Historia desconhecido")
        }
    }

}
