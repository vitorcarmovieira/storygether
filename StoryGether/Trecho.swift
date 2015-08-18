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
    
    func add(){
        
    }
    
    func parseToDictionary() -> [String : String]{
        
        var dictionary = [String : String]()
        
        dictionary["trecho"] = parseObject["trecho"] as? String
        dictionary["quantFav"] = (parseObject["quantFav"] as? NSNumber)?.description
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
        
        if let userObjectId = PFUser.currentUser(){
            var dictionary = [String : AnyObject]()
            dictionary["user"] = userObjectId
            dictionary["trecho"] = self.parseObject
            
            self.hasValueInClass("favoritadasTrecho", dictionary: dictionary, block: {
                bool in
                if !bool{
                    let favoritada = PFObject(className: "favoritadasTrecho")
                    for (key, value) in dictionary{
                        favoritada[key] = value
                    }
                    
                    favoritada.saveInBackgroundWithBlock{
                        (succeeded, error) in
                        if error == nil{
                            //salvar no local tambem
                        }
                    }
                }
            })
        }
    }
    
}