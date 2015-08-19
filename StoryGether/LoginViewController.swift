//
//  LoginViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 28/06/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse
import Foundation

class LoginViewController:   UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var btLoginFb: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.delegate=self
        tfPassword.delegate=self
        
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

    @IBAction func forgotPassword(sender: AnyObject) {
    }
    @IBAction func login(sender: AnyObject) {
        
        let name = self.tfEmail.text
        let password = self.tfPassword.text
        
        PFUser.logInWithUsernameInBackground(name , password: password, block: {
            (usuario, error) in
            if usuario == nil{
                println("Falha em logar \(error)")
            }else{
                
                self.callMainScreen()
            }
        })
    }
    
    @IBAction func loginFB(sender: AnyObject) {
        let loginM = FBSDKLoginManager()
        
        loginM.logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: {
            result,error in
            print("User logged in.")
            
            if ((error) != nil){
                // Process error
            }
            else if result.isCancelled {
                // Handle cancellations
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email"){
                    
                    let accessToken = FBSDKAccessToken.currentAccessToken()
                    PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block:{
                        (user: PFUser?, error: NSError?) -> Void in
                        if user != nil {
                            println("User logged in through Facebook!")
                            self.setUserData()
                        } else {
                            println("Uh oh. There was an error logging in.")
                        }
                    })
                }
            }
        })
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("user logout")
    }
    
    
    func setUserData()
    {
        var name: NSString!
        var urlFoto: NSString!
        var id: NSString!
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,picture.height(300).weight(300)", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
                if let n = result.valueForKey("name") as? NSString{
                    name = n
                }
                
                if let ident = result.valueForKey("id") as? NSString{
                    id = ident
                }
                
                var pic: AnyObject? = result.valueForKey("picture")
                var data: AnyObject? = pic?.valueForKey("data")
                
                if let url = data?.valueForKey("url") as? NSString{
                    urlFoto = url
                }
                
                let user = PFUser.currentUser()!
                user["name"] = name
                user["urlFoto"] = urlFoto
                user["idFace"] = id
                user.saveInBackgroundWithBlock{
                    (successed, error) in
                    if error == nil{
                        let rootView = self.storyboard?.instantiateViewControllerWithIdentifier("rootTabBar") as! TabBarController
                        self.presentViewController(rootView, animated: true, completion: nil)
                    }
                }
                
                let currentUser = NSUserDefaults.standardUserDefaults()
                currentUser.setValue(name, forKey: "nome")
                currentUser.setValue(urlFoto, forKey: "urlFoto")
                currentUser.setValue(id, forKey: "idFace")
            }
        })
        
    }
    
    @IBAction func createAccount(sender: AnyObject) {
    }
    
    func callMainScreen(){
        
        let rootView = self.storyboard?.instantiateViewControllerWithIdentifier("rootTabBar") as! UITabBarController
        self.presentViewController(rootView, animated: true, completion: nil)
    }
    
}
