//
//  LoginViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 28/06/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UIScrollViewDelegate, FBSDKLoginButtonDelegate{
    @IBOutlet weak var svTutorial: UIScrollView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btLogin: UIButton!
    var images: NSArray!
    var titles: NSArray!
    var subs: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.images = NSArray(array: [UIImage(named: "storygether_telainicial1")!,UIImage(named: "storygether_telainicial2")!,UIImage(named: "storygether_telainicial3")!]);
        self.titles = NSArray(array: ["Make stories","Begin a story","Have fun"])
        self.subs = NSArray(array: ["with your friends","or continue one","and be creative"])
        
        self.svTutorial.delegate=self
        
        for (var i: Int = 0; i < self.images.count; i++) {
            
            var image: UIImage  = self.images[i] as! UIImage;
            var imageview: UIImageView  = UIImageView(image: image)
            
            var frame:CGRect = CGRect()
            
            frame.origin.x = self.svTutorial.frame.size.width * CGFloat(i)
            
            frame.origin.y = 0
            
            frame.size = self.svTutorial.frame.size
            
            imageview.frame = frame
            
            self.svTutorial.addSubview(imageview)
        }
        
        self.svTutorial.contentSize =
            CGSizeMake(self.svTutorial.frame.size.width * CGFloat(self.images.count), self.svTutorial.frame.size.height)
        
//        if (FBSDKAccessToken.currentAccessToken() != nil){
//            println("logado")
//        }
//        else{
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
            loginView.bounds.size = self.btLogin.bounds.size
            loginView.center = self.btLogin.center
            self.view.addSubview(loginView)
//        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
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
                
                PFFacebookUtils.logInInBackgroundWithAccessToken(FBSDKAccessToken.currentAccessToken())
                setUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        print("user logout")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth: CGFloat = self.svTutorial.frame.size.width;
        
        var page: Int  = Int(floor((self.svTutorial.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1;
        self.lbTitle.text = self.titles[page] as? String
        self.lbSub.text = self.subs[page] as? String
        self.pageControl.currentPage = page;
    }
    
    func setUserData()
    {
        let userData: NSMutableDictionary = NSMutableDictionary(capacity: 7)
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,picture", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
                if let name = result.valueForKey("name") as? NSString{
                    
                    userData.setValue(name, forKey: "name")
                }
                
                if let id = result.valueForKey("id") as? NSString{
                    
                    userData.setValue(id, forKey: "id")
                }
                
                var pic: AnyObject? = result.valueForKey("picture")
                var data: AnyObject? = pic?.valueForKey("data")
                var url = data?.valueForKey("url") as! String
                
                if let url = data?.valueForKey("url") as? NSString{
                    
                    userData.setValue(url, forKey: "urlFoto")
                }
//                var urlRequest = NSURLRequest(URL: NSURL(string: url)!)
//                if let url = NSURL(string: url) {
//                    if let imageData = NSData(contentsOfURL: url){
//                        
//                        userData.setValue(imageData, forKey: "image")
//                    }
//                }
                
                PFUser.currentUser()?.setObject(userData, forKey: "profile")
                PFUser.currentUser()?.saveInBackground().continueWithBlock({
                    (task) -> AnyObject in
                    if task.error != nil{
                        return task
                    }
                    
                    print("\(task)")
                    return task
                })
            }
        })
        
    }
}
