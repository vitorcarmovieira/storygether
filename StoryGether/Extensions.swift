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