//
//  PerfilViewController.swift
//  StoryGether
//
//  Created by Vitor on 7/20/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import UIKit
import Parse

class PerfilViewController: UIViewController {
    
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    
    override func viewDidLoad() {
        
        self.imagemView.circularImageView()
        
        let currentUser: AnyObject? = PFUser.currentUser()?.valueForKey("profile")
        
        self.nomeLabel.text = currentUser?.valueForKey("name") as? String
        
        let url = currentUser?.valueForKey("urlFoto") as? String
        var urlRequest = NSURLRequest(URL: NSURL(string: url!)!)
        if let url = NSURL(string: url!) {
            if let imageData = NSData(contentsOfURL: url){
        
                self.imagemView.image = UIImage(data: imageData)
            }
        }
    }

}
