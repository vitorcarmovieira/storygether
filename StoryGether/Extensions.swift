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
    
    func getImageAssync(url: String?){
        
        if let url = url{
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                if let nsurl = NSURL(string: url){
                    if let data = NSData(contentsOfURL: nsurl){
                        if let image = UIImage(data: data){
                            dispatch_async(dispatch_get_main_queue()) {
                                self.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}

extension NSDate{
    
    func historyCreatedAt() -> String{
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        return "Criada em: " + dateFormat.stringFromDate(self)
    }
}