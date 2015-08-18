//
//  Historia.swift
//  StoryGether
//
//  Created by Vitor on 8/17/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import Parse

class Historia{
    
    private var parseObject: PFObject!
    
    lazy var trechos: TrechosStore? = {
        
        return TrechosStore(object: self.parseObject)
        
    }()
    
    init(parseObject: PFObject){
        
        self.parseObject = parseObject
        
    }
    
    func add(){
        
        
        
    }
    
    func parseToDictionary() -> [String : String]{
        
        var dictionary = [String : String]()
        
        dictionary["titulo"] = parseObject["titulo"] as? String
        dictionary["trechoInicial"] = parseObject["trechoInicial"] as? String
        dictionary["createdAt"] = parseObject.createdAt?.historyCreatedAt()
        dictionary["quantFav"] = (parseObject["quantFav"] as? NSNumber)?.description
        dictionary["quantTrechos"] = (parseObject["quantTrechos"] as? NSNumber)?.description
        
        if let user = parseObject["criador"] as? PFUser{
            dictionary["urlFoto"] = user["urlFoto"] as? String
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
            dictionary["userId"] = userObjectId
            dictionary["historiaId"] = self.parseObject
            
            self.hasValueInClass("favoritadas", dictionary: dictionary, block: {
                bool in
                if !bool{
                    let favoritada = PFObject(className: "favoritadas")
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