//
//  Trecho.swift
//  StoryGether
//
//  Created by Vitor on 8/17/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import Parse

class Trecho{
    
    private var parseObject: PFObject!
    
    init(parseObject: PFObject){
        
        self.parseObject = parseObject
        
    }
    
    func parseToDictionary() -> [String : AnyObject]{
        
        var dictionary = [String : AnyObject]()
        
        dictionary["trecho"] = parseObject["trecho"] as? String
        dictionary["quantFav"] = (parseObject["quantFav"] as? NSNumber)?.description
        dictionary["buttonFavoritar"] = Usuario.currentUser.hasUserFavThisStory(parseObject.objectId!)
        if let user = parseObject["escritor"] as? PFUser{
            dictionary["urlFoto"] = user["urlFoto"] as? String
            dictionary["nome"] = user["name"] as? String
        }
        
        return dictionary
    }
    
    func hasValueInClass(className: String ,dictionary: [String : AnyObject], block: (Bool) -> ()){
        
        let query = PFQuery(className: className)
        for (key, value) in dictionary{
            query.whereKey(key, equalTo: value)
        }
        query.countObjectsInBackgroundWithBlock{
            (count, error) in
            if error == nil{
                if count == 0{
                    block(false)
                }else { block(true) }
            }
        }
    }
    
    func favoritar(){
        
        if Usuario.currentUser.hasUserFavThisStory(self.parseObject.objectId!){
            //alertar o usuario que ele ja favoritou
            return
        }
        
        var dictionary = [String : AnyObject]()
        dictionary["user"] = PFUser.currentUser()!
        dictionary["trecho"] = self.parseObject
        
        let favoritada = PFObject(className: "favoritadasTrecho")
        for (key, value) in dictionary{
            favoritada[key] = value
        }
        favoritada.saveInBackgroundWithBlock{
            (succeeded, error) in
            if error == nil{
                Usuario.currentUser.addFav(self.parseObject.objectId!)
            }
        }
    }
    
}