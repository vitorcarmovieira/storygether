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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)
        
        var findTimelineData:PFQuery = PFQuery(className: "Historias")
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            
            if error == nil{
                if let historias = objects as? [PFObject] {
                    
                    for historia in historias {
                        println("\(historia)")
                        self.timelineData.addObject(historia)
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func update(){
        
        print("updating...\n")
        updateData()
        self.refreshControl?.endRefreshing()
    }
    
    func updateData(){
        
        var findTimelineData:PFQuery = PFQuery(className: "Historias")
        let date = self.timelineData.lastObject?.createdAt
        findTimelineData.whereKey("createdAt", greaterThan: date!!)
        
        findTimelineData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            
            if error == nil{
                if let historias = objects as? [PFObject] {
                    
                    for historia in historias {
                        println("\(historia)")
                        self.timelineData.addObject(historia)
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    self.tableView.reloadData()
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
        return self.timelineData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HistoriaTableViewCell
        
        let historia = self.timelineData.objectAtIndex(indexPath.row) as! PFObject
        let user:AnyObject = historia["criador"]!
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        cell.userImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: user.valueForKey("urlFoto") as! String)!)!)
        cell.tituloHistoria.text = (historia["titulo"] as! String)
        cell.dataCriacao.text = "Criada em: " + dateFormat.stringFromDate(historia.createdAt!)
        cell.historiaTextView.text = historia["trechoInicial"] as! String

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
            var historiaTVC = segue.destinationViewController as! TrechosViewController
            let index: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let historia: PFObject = self.timelineData.objectAtIndex(index.row) as! PFObject
            historiaTVC.Historia = historia
    }
    
    

}
