//
//  Model.swift
//  StoryGether
//
//  Created by Vitor on 7/31/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import Parse

protocol HistoriaDelegate{
    func didChangeStories()
    func willChangeStories()
}

class Model{
    
    private var myContext = 0
    
    var delegate: HistoriaDelegate?
    
    typealias dic = [String : String]
    
    enum ClassTypes: String{
        case Historia = "Historias"
        case Trecho = "Trechos"
        case Seguidores = "seguidores"
    }
    
    //SINGLETONS
    
    static let sharedStore = Model()
    
    //-----------------------------------------
    
    private var items = [Historia]()
    
    //CONSTRUTORES
    
    private init (){

        self.update()
    }
    
    //-----------------------------------------
    
    
    func getAllItems() -> [Historia]{
        return self.items
    }
    
    func update(){
        
        fetchFromLocalWithClassName(completion: {
            objects in
            self.items = objects
            self.delegate?.didChangeStories()
        })
        self.delegate?.willChangeStories()
        fetchParseObjectsWithClassName(completion: {
            objects in
            self.items = objects
            self.delegate?.didChangeStories()
        })
    }
    
    func getAllHistoriasAmigos(){
        
        let queryAmigos = PFQuery(className: ClassTypes.Seguidores.rawValue)
        queryAmigos.whereKey("seguindoId", equalTo: PFUser.currentUser()!)
        queryAmigos.includeKey("seguidoId")
        
        queryAmigos.findObjectsInBackgroundWithBlock{
            (objects, error) in
            if error == nil{
                var amigos:[PFUser] = []
                for obj in objects as! [PFObject]{
                    amigos.append(obj["seguidoId"] as! PFUser)
                }
                
                let query = PFQuery(className: ClassTypes.Historia.rawValue)
                query.whereKey("criador", containedIn: amigos)
                query.orderByDescending("createdAt")
                query.includeKey("criador")
                query.findObjectsInBackgroundWithBlock{
                    (objects, error) in
                    if error == nil{
                        if let objects = objects as? [PFObject]{
                            var historias: [Historia] = []
                            for obj in objects{
                                let historia = Historia(parseObject: obj)
                                historias.append(historia)
                            }
                            self.items = historias
                        }
                        self.delegate?.didChangeStories()
                    }
                }
            }
        }
    }
    
    func fetchFromLocalWithClassName(predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123") ,completion: ([Historia]) -> ()){
        
        let className = "Historias"
        var query:PFQuery = PFQuery(className: className, predicate: predicate)
        query.fromPinWithName(className)
        query.orderByDescending("createdAt")
        query.includeKey("criador")
            
        query.findObjectsInBackgroundWithBlock{
            (objects, error) in
            if error == nil{
                
                var historias: [Historia] = []
                
                if let objects = objects as? [PFObject]{
                    for obj in objects{
                        let historia = Historia(parseObject: obj)
                        historias.append(historia)
                    }
                }
                
                completion(historias)
            }
        }
        
    }
    
    func fetchParseObjectsWithClassName(predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123"), completion: ([Historia]) -> ()){
        
        let className = "Historias"
        var query:PFQuery = PFQuery(className: className, predicate: predicate)
        query.orderByDescending("createdAt")
        query.includeKey("criador")
            
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            if error == nil{
                if let objects = objects as? [PFObject]{
                    if let className = objects.first?.parseClassName{
                        PFObject.unpinAllObjectsInBackgroundWithName(className, block: {
                            (error) in
                            PFObject.pinAllInBackground(objects, withName: className)
                            var historias: [Historia] = []
                            for obj in objects{
                                let historia = Historia(parseObject: obj)
                                historias.append(historia)
                            }
                            completion(historias)
                        })
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
    
    func seguir(id: PFUser){
        
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



protocol TrechoDelegate{
    func didChangeStretch()
}


class TrechosStore{
    
    private var items = [Trecho]()
    
    var delegate: TrechoDelegate?
    
    init(object: PFObject){
        
        self.update(object)
        
    }
    
    func getAll() -> [Trecho]{
        return self.items
    }
    
    func update(object: PFObject){
        
        let predicate = NSPredicate(format: "historia == %@", object)
        fetchFromLocalWithClassName(predicate: predicate, completion: {
            objects in
            self.items = objects
            self.delegate?.didChangeStretch()
        })
        
        fetchParseObjectsWithClassName(predicate: predicate, completion: {
            objects in
            self.items = objects
            self.delegate?.didChangeStretch()
        })
    }
    
    func fetchFromLocalWithClassName(predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123") ,completion: ([Trecho]) -> ()){
        
        let className = "Trechos"
        
        var query:PFQuery = PFQuery(className: className, predicate: predicate)
        query.fromPinWithName(className)
        query.orderByAscending("createdAt")
        query.includeKey("escritor")
        query.includeKey("historia")
        
            
        query.findObjectsInBackgroundWithBlock{
            (objects, error) in
            if error == nil{
                
                var trechos: [Trecho] = []
                
                if let objects = objects as? [PFObject]{
                    for obj in objects{
                        let trecho = Trecho(parseObject: obj)
                        trechos.append(trecho)
                    }
                }
                
                completion(trechos)
            }
        }
        
    }
    
    func fetchParseObjectsWithClassName(predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123"), completion: ([Trecho]) -> ()){
        
        let className = "Trechos"
        var query:PFQuery = PFQuery(className: className, predicate: predicate)
        query.orderByAscending("createdAt")
        query.includeKey("escritor")
        query.includeKey("historia")
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            if error == nil{
                if let objects = objects as? [PFObject]{
                    if let className = objects.first?.parseClassName{
                        
                        PFObject.unpinAllObjectsInBackgroundWithName(className, block: {
                            (error) in
                            PFObject.pinAllInBackground(objects, withName: className)
                            var trechos: [Trecho] = []
                            for obj in objects{
                                let trecho = Trecho(parseObject: obj)
                                trechos.append(trecho)
                            }
                            completion(trechos)
                        })
                    }
                }
            }else{
                query.fromPinWithName(className)
                query.findObjectsInBackgroundWithBlock{
                    (objects:[AnyObject]?, error:NSError?)->Void in
                    if error == nil{
                        if let objects = objects as? [PFObject]{
                            if let className = objects.first?.parseClassName{
                                var trechos: [Trecho] = []
                                for obj in objects{
                                    let trecho = Trecho(parseObject: obj)
                                    trechos.append(trecho)
                                }
                                completion(trechos)
                            }
                        }
                    }
                }
            }
        }
    }
    
}