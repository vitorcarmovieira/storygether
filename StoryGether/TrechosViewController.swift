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

    var Historia: PFObject?
    var id:String!
    var trechosList:[PFObject]!
    var frameView: CGRect!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTrechoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trechosList = []

        var query: PFQuery = PFQuery(className: "Trechos")
        self.id = self.Historia?.objectId!
        query.whereKey("historia", equalTo: id)
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?) ->Void in
            
            if error == nil{
                if let trechos = objects as? NSArray {
                    
                    for trecho in trechos {
                        
                        println("Finded: \(trecho)")
                        
                        let t: PFObject = trecho as! PFObject
                        
                        self.trechosList.append(t)
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        self.frameView = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        
        
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTrecho(sender: AnyObject) {
        
        var trecho: PFObject = PFObject(className: "Trechos")
        trecho["trecho"] = self.newTrechoTextView.text!
        let className = PFUser.currentUser()?.parseClassName
        trecho["escritor"] = PFUser.currentUser()?.valueForKey("profile")
        trecho["historia"] = self.id
        
        trecho.saveInBackground()
        
        trechosList.append(trecho)
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
        
        let user:AnyObject!
        
        if indexPath.row == 0{
            
            let header = tableView.dequeueReusableCellWithIdentifier("trechoHeaderCell") as! HeaderTableViewCell
            
            let trecho:PFObject = self.trechosList[indexPath.row]
            header.trechoTextView.text = trecho["trecho"] as! String
            header.tituloHistoriaText.text = (self.Historia!["titulo"] as! String)
            user = trecho["escritor"]
            println("\(user)")
            header.imagemCriador.image = UIImage(data: NSData(contentsOfURL: NSURL(string: user.valueForKey("urlFoto") as! String)!)!)
            header.nomeCriadorLabel.text = user.valueForKey("name") as? String
            
            return header
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trechoCell", forIndexPath: indexPath) as! trechoTableViewCell
        
        let trecho: PFObject = self.trechosList[indexPath.row]
        user = trecho["escritor"]
        cell.trechoTextView.text = trecho["trecho"] as! String
        cell.imagemEscritorTrecho.image = UIImage(data: NSData(contentsOfURL: NSURL(string: user.valueForKey("urlFoto") as! String)!)!)
        
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
    
    //---------------------- move up textView ---------------------

    func keyboardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.frameView = CGRectMake(0, (self.frameView.origin.y - keyboardHeight + tabBarHeight!), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
        self.view.frame = self.frameView
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.frameView = CGRectMake(0, (self.frameView.origin.y + keyboardHeight - tabBarHeight!), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
        self.view.frame = self.frameView
        
    }
    
    //---------------------- move up textView ---------------------
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
