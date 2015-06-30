//
//  LoginViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 28/06/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UIScrollViewDelegate, FBSDKLoginButtonDelegate {
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
        
        if (FBSDKAccessToken.currentAccessToken() != nil){
            println("logado")
        }
        else{
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            loginView.frame = self.btLogin.frame
            self.view.addSubview(loginView)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
            
            setUserData()
            
            let rootView = self.storyboard?.instantiateViewControllerWithIdentifier("rootTabBar") as! UITabBarController
            self.presentViewController(rootView, animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
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
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                let currentUser = NSUserDefaults.standardUserDefaults()
                
                println("fetched user: \(result)")
                
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                currentUser.setObject(userName, forKey: "nome")
                
                //                let userEmail : NSString = result.valueForKey("email") as! NSString
                //                println("User Email is: \(userEmail)")
            }
        })
        
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                println("\(result)")
                
                var data = result.valueForKey("data")
                var url = data?.valueForKey("url") as! String
                var urlRequest = NSURLRequest(URL: NSURL(string: url)!)
                if let url = NSURL(string: url) {
                    if let data = NSData(contentsOfURL: url){
                        
                        
                    }
                }
                
            } else {
                println("\(error)")
            }
        })
    }
}
