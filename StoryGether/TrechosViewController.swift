//
//  TrechosViewController.swift
//  StoryGether
//
//  Created by Vitor on 6/21/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class TrechosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var idHistoria: String?
    var trechosList: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTrechoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query: PFQuery = PFQuery(className: "Trechos")
        
        query.whereKey("escritor", equalTo: self.idHistoria!)
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) ->Void in
            
            if error == nil{
                if let trechos = objects as? NSArray {
                    
                    for trecho in trechos {
                        
                        println("Finded: \(trecho)")
                        
                        let t: PFObject = trecho as! PFObject
                        
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
    
    @IBAction func addTrecho(sender: AnyObject) {
        
        var trecho: PFObject = PFObject(className: "Trechos")
        trecho["texto"] = self.newTrechoTextView.text!
        trecho["escritor"] = idHistoria!
        
        trecho.saveInBackground()
        
        trechosList.addObject(trecho)
        self.tableView.reloadData()
        self.newTrechoTextView.text = ""
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.trechosList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            
            let header = tableView.dequeueReusableCellWithIdentifier("trechoHeaderCell") as! HeaderTableViewCell
            
            let trecho: AnyObject = self.trechosList[indexPath.row]
            header.trechoTextView.text = trecho.valueForKey("texto") as? String
            
            return header
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trechoCell", forIndexPath: indexPath) as! trechoTableViewCell
        
        let trecho: AnyObject = self.trechosList[indexPath.row]
        println("\(trecho)")
        cell.trechoTextView.text = trecho.valueForKey("texto") as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return 182
        } else{
            
            return 100
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Titulo"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
