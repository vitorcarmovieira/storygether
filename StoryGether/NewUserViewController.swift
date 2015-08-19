//
//  NewUserViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 17/08/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class NewUserViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var nextTag = textField.tag + 1;
        // Try to find next responder
        if let nextResponder = textField.superview?.viewWithTag(nextTag){
            // Found next responder, so set it.
            nextResponder.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func createUser(sender: AnyObject) {
       
        let user = PFUser()
        
        user.username = self.tfEmail.text
        user.email = self.tfEmail.text
        user["name"] = self.tfName.text
        user.password = self.tfPassword.text
        
        user.signUpInBackgroundWithBlock{
            (succeeded, error) in
            if let error = error{
                let erroString = error.userInfo?["error"] as? String
                println("\(erroString)")
            }else {
                self.callMainScreen()
            }
        }
        
    }
    
    @IBAction func loginFB(sender: AnyObject) {
    }
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func callMainScreen(){
        
        let rootView = self.storyboard?.instantiateViewControllerWithIdentifier("rootTabBar") as! UITabBarController
        self.presentViewController(rootView, animated: true, completion: nil)
    }
}
