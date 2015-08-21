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
    
    class func add(titulo: String, trecho: String){
        
        var novahistoria:PFObject = PFObject(className: "Historias")
        novahistoria["titulo"] = titulo
        novahistoria["criador"] = PFUser.currentUser()!
        novahistoria["trechoInicial"] = trecho
        novahistoria.saveInBackgroundWithBlock{
            (succeeded, error) in
            if error == nil{
                var novoTrecho: PFObject = PFObject(className: "Trechos")
                novoTrecho["trecho"] = trecho
                novoTrecho["escritor"] = PFUser.currentUser()!
                novoTrecho["historia"] = novahistoria
                novoTrecho.saveInBackgroundWithBlock{
                    (succeeded, error) in
                    if error == nil{
                        novahistoria.pinInBackgroundWithName("Historias")
                        novoTrecho.pinInBackgroundWithName("Trechos")
                        Model.sharedStore.update()
                    }
                }
                
            }
        }
        
    }
    
    func addTrecho(trechoText: String){
        
        var trecho: PFObject = PFObject(className: "Trechos")
        trecho["trecho"] = trechoText
        trecho["escritor"] = PFUser.currentUser()!
        let historia = PFObject(withoutDataWithClassName: "Historias", objectId: self.parseObject.objectId!)
        trecho["historia"] = historia
        trecho.saveInBackgroundWithBlock{
            (succeeded, error) in
            trecho.pinInBackgroundWithName("Trechos")
            Model.sharedStore.update()
        }
        
    }
    
    func parseToDictionary() -> [String : AnyObject]{
        
        var dictionary = [String : AnyObject]()
        
        dictionary["titulo"] = parseObject["titulo"] as? String
        dictionary["trechoInicial"] = parseObject["trechoInicial"] as? String
        dictionary["createdAt"] = parseObject.createdAt?.historyCreatedAt()
        dictionary["quantFav"] = (parseObject["quantFav"] as? NSNumber)?.description
        dictionary["quantTrechos"] = (parseObject["quantTrechos"] as? NSNumber)?.description
        dictionary["buttonFavoritar"] = Usuario.currentUser.hasUserFavThisStory(parseObject.objectId!)
        
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
        
        if Usuario.currentUser.hasUserFavThisStory(self.parseObject.objectId!){
            //alertar o usuario que ele ja favoritou
            return
        }
        
        var dictionary = [String : AnyObject]()
        dictionary["userId"] = PFUser.currentUser()!
        dictionary["historiaId"] = self.parseObject
        
        let favoritada = PFObject(className: "favoritadas")
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