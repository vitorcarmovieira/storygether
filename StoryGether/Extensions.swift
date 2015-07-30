//
//  Extensions.swift
//  StoryGether
//
//  Created by Vitor on 7/28/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation

extension UIImageView{
    
    func circularImageView(){
        
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
        
    }
    
    func getImageAssync(url: String){
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            let image = UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)
            dispatch_async(dispatch_get_main_queue()) {
                self.image = image
            }
        }
    }
}

extension UIButton{
    
    func customButtonWithImage(image: UIImage, andText: String){
        
        self.setBackgroundImage(image, forState: UIControlState.Normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0.0)
        self.titleLabel?.text = "Historias"
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
}