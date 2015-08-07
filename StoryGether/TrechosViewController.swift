//
//  TrechosViewController.swift
//  StoryGether
//
//  Created by Vitor on 6/21/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse
import CoreData

class TrechosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, NSFetchedResultsControllerDelegate {

    var Historia: Historias?
    var id:String!
    var trechosList:[Trechos]!
    var frameView: CGRect!
    var fetchedResultsController: NSFetchedResultsController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTrechoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.updateTrecho(self.Historia!)
        
        let objectId = self.Historia?.objectId
        let predicate = NSPredicate(format: "historia.objectId == %@", objectId!)
        fetchedResultsController = Trechos.fetchedResultsController("createdAt", ascending: true, predicate: predicate)
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
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
        
        let trechoText = self.newTrechoTextView.text!
        let user = Usuarios.getCurrent()!
        
        Trechos.createWithTrecho(trechoText, escritor: user, historia: self.Historia!, createdAt: NSDate())
        
        var trecho: PFObject = PFObject(className: "Trechos")
        trecho["trecho"] = self.newTrechoTextView.text!
        let className = PFUser.currentUser()?.parseClassName
        trecho["escritor"] = PFUser.currentUser()!
        let historia = PFObject(withoutDataWithClassName: "Historias", objectId: self.Historia?.objectId)
        trecho["historia"] = historia
        trecho.saveInBackgroundWithBlock{
            (succeeded, error) in
            historia.fetchIfNeededInBackgroundWithBlock{
                (object, error) in
                if error == nil{
                    if let historia = object{
                        if var trechos = historia["trechos"] as? [PFObject]{
                            trechos.append(trecho)
                            historia["trechos"] = trechos
                            historia.saveInBackground()
                        }else{
                            historia["trechos"] = [trecho]
                            historia.saveInBackground()
                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
        self.newTrechoTextView.text = ""
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        return self.trechosList.count
        let sec = self.fetchedResultsController.sections as! [NSFetchedResultsSectionInfo]
        
        return sec[section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let user:AnyObject!
        
        if indexPath.row == 0{
            
            let header = tableView.dequeueReusableCellWithIdentifier("trechoHeaderCell") as! HeaderTableViewCell
            
            header.trecho = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Trechos
            header.tituloHistoria = self.Historia?.titulo
            header.awakeFromNib()
            
            return header
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("trechoCell", forIndexPath: indexPath) as! trechoTableViewCell
        
        let trecho = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Trechos
        
        cell.trecho = trecho
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
            
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            print("Trecho inserido")
            
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Top)
            print("Trecho deletado")
            
        case .Update:
            print("Trecho atualizado")
            
        default:
            print("Tipo desconhecido")
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

}
