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

    var timelineData:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var findTimelineData:PFQuery = PFQuery(className: "Historias")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            
            if error == nil{
                if let historias = objects as? NSArray {
                    
                    for historia in historias {
                        
                        println("\(historia)")
                        self.timelineData.addObject(historia)
                    }
                }
                
                
                self.tableView.reloadData()
                
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
        return self.timelineData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoriaTableViewCell
        let historia: PFObject = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.historiaTextView.text = historia.valueForKey("titulo") as! String

        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! UITableViewCell
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let height = 40.0 as CGFloat
        
        return height
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            var historiaTVC = segue.destinationViewController as! HistoriaTableViewController
            let index: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let historia: PFObject = self.timelineData.objectAtIndex(index.row) as! PFObject
            historiaTVC.idHistoria = historia.valueForKey("objectId") as? String
    }

}
