//
//  Model.swift
//  StoryGether
//
//  Created by Vitor on 7/31/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import Parse

class Model {
    
    typealias dic = [String : String?]
    
    enum ClassTypes{
        case Historia
        case Usuario
    }
    
    class func countInClassName(className: String, collum: String, objectId: String, isPointer: Bool, completion: (String) -> ()){
        
        let cache = Cache<NSString>(name: className)
        
        if let cont = cache[objectId]{
            
            completion(cont as String)
            println("favoritada no cache \(cont)")
            
        }else{
        
            let query = PFQuery(className: className)
            query.whereKey(collum, equalTo: (isPointer ? PFObject(withoutDataWithClassName: className, objectId: objectId) : objectId))
            query.countObjectsInBackgroundWithBlock{
                (num, error) in
                if error == nil{
                    cache.setObject(num.description as NSString, forKey: objectId, expires: .Date(NSDate().dateByAddingTimeInterval(60*60*24*7)))
                    completion(num.description)
                }
            }
        }
    }
    
    class func fetchFromLocalWithClassName(className: String, predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123"), completion: ([dic]) -> ()){
        
        var query:PFQuery
        
        func queryParse(query: PFQuery){
            
            query.findObjectsInBackgroundWithBlock{
                (objects:[AnyObject]?, error:NSError?)->Void in
                if error == nil{
                    if let objects = objects as? [PFObject]{
                        if let className = objects.first?.parseClassName{
                            switch className{
                            case "Historias":
                                completion(self.parseToDictionary(className, objects: objects))
                            case "Trechos":
                                completion(self.parseToDictionary(className, objects: objects))
                            default:
                                println("error in className \(className)")
                            }
                        }
                    }
                }
            }
        }
        
        if className == "Historias"{
            var query:PFQuery = PFQuery(className: className, predicate: predicate)
            query.fromPinWithName(className)
            query.orderByDescending("createdAt")
            query.includeKey("criador")
            queryParse(query)
            
        }else if className == "Trechos"{
            var query:PFQuery = PFQuery(className: className, predicate: predicate)
            query.fromPinWithName(className)
            query.orderByAscending("createdAt")
            query.includeKey("escritor")
            query.includeKey("historia")
            queryParse(query)
        }
        
    }
    
    class func fetchParseObjectsWithClassName(className:String, predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123"), completion: ([dic]) -> ()){
        
        var query:PFQuery
        
        func queryParse(query: PFQuery){
            
            query.findObjectsInBackgroundWithBlock{
                (objects:[AnyObject]?, error:NSError?)->Void in
                if error == nil{
                    if let objects = objects as? [PFObject]{
                        if let className = objects.first?.parseClassName{
                            switch className{
                            case "Historias":
                                PFObject.unpinAllObjectsInBackgroundWithName(className, block: {
                                    (error) in
                                    PFObject.pinAllInBackground(objects, withName: className)
                                    completion(self.parseToDictionary(className, objects: objects))
                                })
                            case "Trechos":
                                PFObject.unpinAllObjectsInBackgroundWithName(className, block: {
                                    (error) in
                                    PFObject.pinAllInBackground(objects, withName: className)
                                    completion(self.parseToDictionary(className, objects: objects))
                                })
                            default:
                                println("error in className \(className)")
                            }
                        }
                    }
                }else{
                    query.fromPinWithName(className)
                    query.findObjectsInBackgroundWithBlock{
                        (objects:[AnyObject]?, error:NSError?)->Void in
                        if error == nil{
                            if let objects = objects as? [PFObject]{
                                if let className = objects.first?.parseClassName{
                                    switch className{
                                    case "Historias":
                                        completion(self.parseToDictionary(className, objects: objects))
                                    case "Trechos":
                                        completion(self.parseToDictionary(className, objects: objects))
                                    default:
                                        println("error in className \(className)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if className == "Historias"{
            var query:PFQuery = PFQuery(className: className, predicate: predicate)
            query.orderByDescending("createdAt")
            query.includeKey("criador")
            queryParse(query)
            
        }else if className == "Trechos"{
            var query:PFQuery = PFQuery(className: className, predicate: predicate)
            query.orderByAscending("createdAt")
            query.includeKey("escritor")
            query.includeKey("historia")
            queryParse(query)
        }
        
        
    }
    
    class func parseToDictionary(className: String, objects: [PFObject]) -> [dic]{
        
        var dictionary = [dic]()
        
        switch className{
        case "Historias":
        
            for (i, object) in enumerate(objects){
                
                var values = dic()
                values["objectId"] = object.objectId
                values["titulo"] = object["titulo"] as? String
                values["trechoInicial"] = object["trechoInicial"] as? String
                values["createdAt"] = object.createdAt?.historyCreatedAt()
                if let user = object["criador"] as? PFUser{
                    values["urlFoto"] = user["urlFoto"] as? String
                }
                dictionary.append(values)
                
            }
        
        case "Trechos":
            
            for (i, object) in enumerate(objects){
                
                var values = dic()
                values["objectId"] = object.objectId
                values["trecho"] = object["trecho"] as? String
                values["createdAt"] = object.createdAt?.historyCreatedAt()
                if let user = object["escritor"] as? PFUser{
                    values["urlFoto"] = user["urlFoto"] as? String
                    values["nome"] = user["name"] as? String
                }
                dictionary.append(values)
                
            }
        
        default:
            print("Não foi possivel passar para dicionario a classe \(className)")
            
        }
        
        return dictionary
    }
    
    class func saveParseObjectHistory(titulo: String, trecho: String){
        
        let className = PFUser.currentUser()?.parseClassName
        
        var novahistoria:PFObject = PFObject(className: "Historias")
        novahistoria["titulo"] = titulo
        novahistoria["criador"] = PFUser.currentUser()!
        novahistoria["trechoInicial"] = trecho
        novahistoria.saveInBackgroundWithBlock{
            (succeeded, error) in
            if error == nil{
                println("salvando historia \(titulo)")
                var novoTrecho: PFObject = PFObject(className: "Trechos")
                novoTrecho["trecho"] = trecho
                novoTrecho["escritor"] = PFUser.currentUser()!
                novoTrecho["historia"] = novahistoria
                novoTrecho.saveInBackgroundWithBlock{
                    (succeeded, error) in
                    if error == nil{
                        
                        self.saveUserIfNeededWithPFUser(PFUser.currentUser()!, completition: {
                            user in
                            let historia = Historias.createWithTitle(titulo, createdAt: novahistoria.createdAt!, objectId: novahistoria.objectId!, trechoInicial: trecho, criador: user!, trechos: nil, favoritada: nil)
                            self.saveInLocalObjectsTrecho([novoTrecho], historia: historia!)
                        })
                    }
                }
                
            }
        }
    }
    
    class func saveUserIfNeededWithPFUser(object:PFUser, completition: (Usuarios?) -> ()){
        
        let idFace = object["idFace"] as! String
        
        if let user = Usuarios.hasValue(idFace, InColum: "id"){
            
            println("Usuario já está no local date store.")
            completition(user)
            
        }else{
            if let urlFoto = object["urlFoto"] as? String{
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                    if let nsurl = NSURL(string: urlFoto){
                        if let data = NSData(contentsOfURL: nsurl){
                            dispatch_async(dispatch_get_main_queue()){
                                let user = Usuarios.createWithName(object["name"] as! String, foto: data, id: object["idFace"] as! String, historias: NSSet(), trechos: NSSet(), favoritas: NSSet())
                                completition(user)
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func getAllFollowers(tipo: String, callback: ([PFUser]) -> ()){
        
        var allFollows: [PFUser] = []
        
        switch tipo{
            
        case "followers":
            
            if let idUser = PFUser.currentUser(){
                let query = PFQuery(className: "seguidores")
                query.whereKey("seguindoId", equalTo: idUser)
                query.includeKey("seguidoId")
                query.findObjectsInBackgroundWithBlock{
                    (objects, error) in
                    
                    if error == nil{
                        if let parseObjects = objects as? [PFObject]{
                            for followers in parseObjects{
                                if let user = followers["seguidoId"] as? PFUser{
                                    allFollows.append(user)
                                }
                            }
                            callback(allFollows)
                        }
                    }
                }
            }
            
        case "following":
            
            if let idUser = PFUser.currentUser(){
                let query = PFQuery(className: "seguidores")
                query.whereKey("seguidoId", equalTo: idUser)
                query.includeKey("seguindoId")
                query.findObjectsInBackgroundWithBlock{
                    (objects, error) in
                    
                    if error == nil{
                        if let parseObjects = objects as? [PFObject]{
                            for followers in parseObjects{
                                if let user = followers["seguindoId"] as? PFUser{
                                    allFollows.append(user)
                                }
                            }
                            callback(allFollows)
                        }
                    }
                }
            }
            
        default:
            println("deu merda")
            
        }
    }
    
    class func wasFavoritada(objectId: String, userObjectId: String, block: (Bool) -> ()){
        
        let query = PFQuery(className: "favoritadas")
        query.whereKey("userId", equalTo: userObjectId)
        query.whereKey("historiaId", equalTo: objectId)
        query.countObjectsInBackgroundWithBlock{
            (count, error) in
            if error == nil{
                if count == 0{
                    block(false)
                }else { block(true) }
            }
        }
    }
    
    class func hasValueInClass(className: String ,dictionary: [String : AnyObject], block: (Bool) -> ()){
        
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
    
    class func favoritar(objectId: String, block: (Bool) -> ()){
        
        if let userObjectId = PFUser.currentUser()?.objectId{
            var dictionary = [String : String]()
            dictionary["userId"] = userObjectId
            dictionary["historiaId"] = objectId
            
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
                            block(succeeded)
                        }else { block(succeeded) }
                    }
                }
            })
        }
    }
    
    class func seguir(id: PFUser){
        
        if let userId = PFUser.currentUser(){
            var dictionary = [String : AnyObject]()
            dictionary["seguindoId"] = userId
            dictionary["seguidoId"] = id
            
            self.hasValueInClass("seguidores", dictionary: dictionary, block: {
                bool in
                if !bool{
                    let seguidor = PFObject(className: "seguidores")
                    for (key, value) in dictionary{
                        seguidor[key] = value
                    }
                    seguidor.saveInBackground()
                }
            })
        }
    }
    
}
