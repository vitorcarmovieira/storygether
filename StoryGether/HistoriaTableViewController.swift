//
//  HistoriaTableViewController.swift
//  StoryGether
//
//  Created by Vitor on 5/29/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class HistoriaTableViewController: UITableViewController {

    var idHistoria: String?
    var trechosList: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query: PFQuery = PFQuery(className: "Trechos")
        
        query.whereKey("escritor", equalTo: self.idHistoria!)
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) ->Void in
            
            if error == nil{
                if let trechos = objects as? [PFObject] {
                    
                    for trecho in trechos {
                        
                        let t: PFObject = trecho                        
                        self.trechosList.addObject(t)
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
        return self.trechosList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0{
//            
//            let header = tableView.dequeueReusableCellWithIdentifier("trechoHeaderCell") as! HeaderTableViewCell
//            
//            header.parseObject = self.trechosList[indexPath.row] as? PFObject
//            header.tituloHistoria = self.
//            header.awakeFromNib()
//            
//            return header
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trechoCell", forIndexPath: indexPath) as! trechoTableViewCell
        
        cell.trecho = self.trechosList[indexPath.row] as? Trechos
        cell.awakeFromNib()

        return cell
    }
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let header = tableView.dequeueReusableCellWithIdentifier("trechoHeaderCell") as! HeaderTableViewCell
//        
////        let trecho = self.trechosList[0]
////        header.trechoTextView.text = trecho.valueForKey("texto") as? String
//        
//        return header
//    }
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        let height = 190 as CGFloat
//        return height
//    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = tableView.dequeueReusableCellWithIdentifier("footerCell") as! AddTrechoTableViewCell
        
        return footer
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let height = 128 as CGFloat
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
