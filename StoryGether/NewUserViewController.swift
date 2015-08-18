//
//  NewUserViewController.swift
//  StoryGether
//
//  Created by Vinícius Cerqueira Silva on 17/08/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class NewUserViewController: UIViewController {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createUser(sender: AnyObject) {
        self.signUP({
            (error) in
            
        })
    }
    func signUP(onComplete:(NSError?)->Void){

    }
    @IBAction func loginFB(sender: AnyObject) {
    }
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
