//
//  Extensions.swift
//  StoryGether
//
//  Created by Vitor on 7/28/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import Parse

extension UIImageView{
    
    func circularImageView(){
        
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
        
    }
    
    func setImageAssync(url: String?){
        
        let cache = Cache<NSData>(name: "avatar")
        
        if let image = cache[url!]{
            self.image = UIImage(data: image)
            println("image cachada")
        }else{
            if let url = url{
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                    if let nsurl = NSURL(string: url){
                        if let data = NSData(contentsOfURL: nsurl){
                            cache.setObject(data, forKey: url, expires: .Date(NSDate().dateByAddingTimeInterval(60*60*24*7)))
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
}

extension NSDate{
    
    func historyCreatedAt() -> String{
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        
        return "Criada em: " + dateFormat.stringFromDate(self)
    }
}

extension UITextField{
    
    func espacoInicial(){
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.Always
    }
}

extension TimeLineTableViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let query:PFQuery = PFQuery(className: "_User")
        query.whereKey("name", containsString: searchText)
        query.findObjectsInBackgroundWithBlock{
            (objects, error) in
            if error == nil{
                if let user = objects as? [PFObject]{
                    self.filtered = user
                    if(self.filtered?.count == 0){
                        self.searchActive = false;
                    } else {
                        self.searchActive = true;
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
//        if let users = self.users{
//            self.filtered = users.filter({ (user) -> Bool in
//                let profile:NSDictionary = user.valueForKey("profile")! as! NSDictionary
//                let tmp: NSString = profile["name"] as! String
//                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//                return range.location != NSNotFound
//            })
//            if(self.filtered?.count == 0){
//                searchActive = false;
//            } else {
//                searchActive = true;
//            }
//            self.tableView.reloadData()
//        }
    }

}