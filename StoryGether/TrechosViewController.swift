//
//  TrechosViewController.swift
//  StoryGether
//
//  Created by Vitor on 6/21/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class TrechosViewController: UIViewController, TrechoDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    typealias dic = [String : String]

    var historia: Historia!
    var frameView: CGRect!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTrechoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frameView = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        
        historia.trechos?.delegate = self
        
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func addTrecho(sender: AnyObject) {
        
//        let trechoText = self.newTrechoTextView.text!
//        let user = Usuarios.getCurrent()!
//        
//        var trecho: PFObject = PFObject(className: "Trechos")
//        trecho["trecho"] = self.newTrechoTextView.text!
//        let className = PFUser.currentUser()?.parseClassName
//        trecho["escritor"] = PFUser.currentUser()!
//        let historia = PFObject(withoutDataWithClassName: "Historias", objectId: self.Historia?.objectId)
//        trecho["historia"] = historia
//        trecho.saveInBackgroundWithBlock{
//            (succeeded, error) in
//            Trechos.createWithTrecho(trechoText, escritor: user, historia: self.Historia!, objectId: trecho.objectId!, createdAt: NSDate())
//            historia.fetchIfNeededInBackgroundWithBlock{
//                (object, error) in
//                if error == nil{
//                    if let historia = object{
//                        if var trechos = historia["trechos"] as? [PFObject]{
//                            trechos.append(trecho)
//                            historia["trechos"] = trechos
//                            historia.saveInBackground()
//                        }else{
//                            historia["trechos"] = [trecho]
//                            historia.saveInBackground()
//                        }
//                    }
//                }
//            }
//        }
        
        self.tableView.reloadData()
        self.newTrechoTextView.text = ""
    }
    
    // MARK: - Trecho Delegate Methods
    
    func didChangeStretch() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historia.trechos!.getAll().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user:AnyObject!
        
        if indexPath.row == 0{
            
            let header = tableView.dequeueReusableCellWithIdentifier("trechoHeaderCell") as! HeaderTableViewCell
            
            header._trecho = historia.trechos!.getAll()[indexPath.row]
            header.titulo.text = historia.parseToDictionary()["titulo"]
            header.numFavoritos.text = historia.parseToDictionary()["quantFav"]
            header.numAmigos.text = historia.parseToDictionary()["quantTrechos"]
            header.awakeFromNib()
            
            return header
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trechoCell", forIndexPath: indexPath) as! trechoTableViewCell
        
        cell.trecho = historia.trechos!.getAll()[indexPath.row]
        cell.awakeFromNib()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            
            return 182
        } else{
            
            return 100
        }
    }
    
    //---------------------- move up textView ---------------------

    func keyboardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
