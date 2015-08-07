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
    
    enum ClassTypes{
        case Historia
        case Usuario
    }
    
    class func update(){
        
        hasNewHistory{
            bool in
            if bool{
                if let lastObject = Historias.arrayObject("createdAt", ascending: false).last as? Historias{
                    let predicate = NSPredicate(format: "createdAt > %@", lastObject.createdAt)
                    self.fetchParseObjectsWithClassName("Historia", predicate: predicate)
                }else{
                    println("Nenhuma historia.")
                    self.fetchParseObjectsWithClassName("Historia")
                }
            }
        }
    }
    
    class func updateTrecho(historia: Historias){
        
        let parseHistoria:PFObject = PFObject(withoutDataWithClassName: "Historias", objectId: historia.objectId)
        hasNewTrecho(parseHistoria, historia: historia, completion:{
            bool in
            if bool{
                if let lastObject = historia.trechos?.allObjects.last as? Trechos{
                    let predicate = NSPredicate(format: "(createdAt > %@) AND (historia == %@)", lastObject.createdAt, parseHistoria)
                    self.fetchParseObjectsWithClassName("Trechos", historia: historia, predicate: predicate)
                }else{
                    println("Nenhuma historia.")
                    self.fetchParseObjectsWithClassName("Trechos", historia: historia)
                }
            }
        })
    }
    
    class func hasNewHistory(completion: (bool: Bool) -> ()){
        
        var query:PFQuery = PFQuery(className: "Historias")
        query.countObjectsInBackgroundWithBlock{
            (count:Int32, error:NSError?)->Void in
            if error == nil{
                if let numberLocalObjects = Historias.countObjects(){
                    completion(bool: !(count == Int32(numberLocalObjects)))
                }
            }
        }
    }
    
    class func hasNewTrecho(parseHistoria:PFObject, historia: Historias, completion: (bool: Bool) -> ()){
        
        var query:PFQuery = PFQuery(className: "Trechos")
        query.whereKey("historia", equalTo: parseHistoria)
        query.countObjectsInBackgroundWithBlock{
            (count:Int32, error:NSError?)->Void in
            if error == nil{
                if let numberLocalObjects = historia.trechos?.count{
                    completion(bool: !(count == Int32(numberLocalObjects)))
                }
            }
        }
    }
    
    class func fetchParseObjectsWithClassName(className:String, historia: Historias? = nil, predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123")){
        
        var query:PFQuery
        
        func queryParse(query: PFQuery){
            
            query.findObjectsInBackgroundWithBlock{
                (objects:[AnyObject]?, error:NSError?)->Void in
                if error == nil{
                    if let objects = objects as? [PFObject]{
                        if let className = objects.first?.parseClassName{
                            switch className{
                            case "Historias":
                                self.saveInLocalObjects(objects)
                            case "Trechos":
                                self.saveInLocalObjectsTrecho(objects, historia: historia!)
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
            query.orderByDescending("createdAt")
            query.includeKey("criador")
            query.includeKey("trechos")
            queryParse(query)
            
        }else if className == "Trechos"{
            var query:PFQuery = PFQuery(className: className, predicate: predicate)
            query.orderByDescending("createdAt")
            query.includeKey("escritor")
            query.includeKey("historia")
            queryParse(query)
        }
        
        
    }
    
    class func saveInLocalObjectsTrecho(objects:[PFObject], historia: Historias){
        
        for object in objects{
            
            let trechoText = object["trecho"] as! String
            let user = object["escritor"] as! PFObject
            saveUserWithParse(user, completition: {
                user in
                if let user = user{
                    println("user : \(user)")
                    Trechos.createWithTrecho(trechoText, escritor: user, historia: historia, createdAt: NSDate())
                    Trechos.saveOrUpdate()
                }
            })
        }
    }
    
    class func saveInLocalObjects(objects:[PFObject]){
        
        for object in objects{
            println("\(object)")
            if let criador = object["criador"] as? PFObject{
                let idFace = criador["idFace"] as! String
                
                if let user = Usuarios.hasValue(idFace, InColum: "id"){
                    
                    let titulo = object["titulo"] as! String
                    let objectId = object.objectId!
                    let createdAt = object.createdAt!
                    let trechoInicial = object["trechoInicial"] as! String
                    
                    let historia = Historias.createWithTitle(titulo, createdAt: createdAt, objectId: objectId,trechoInicial: trechoInicial, criador: user, trechos: nil, favoritada: nil)
                    if let trechos = object["trechos"] as? [PFObject]{
                        for trecho in trechos{
                            let trechoText = trecho["trecho"] as! String
                            Trechos.createWithTrecho(trechoText, escritor: user, historia: historia!, createdAt: NSDate())
                        }
                    }
                    
                }else{
                    if let urlFoto = criador["urlFoto"] as? String{
                        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
                            if let nsurl = NSURL(string: urlFoto){
                                if let data = NSData(contentsOfURL: nsurl){
                                    dispatch_async(dispatch_get_main_queue()){
                                        let user = Usuarios.createWithName(criador["name"] as! String, foto: data, id: criador["idFace"] as! String, historias: NSSet(), trechos: NSSet(), favoritas: NSSet())
                                        
                                        let titulo = object["titulo"] as! String
                                        let objectId = object.objectId!
                                        let createdAt = object.createdAt!
                                        let trechoInicial = object["trechoInicial"] as! String
                                        
                                        let historia = Historias.createWithTitle(titulo, createdAt: createdAt, objectId: objectId,trechoInicial: trechoInicial, criador: user, trechos: nil, favoritada: nil)
                                        if let trechos = object["trechos"] as? [PFObject]{
                                            for trecho in trechos{
                                                let trechoText = trecho["trecho"] as! String
                                                Trechos.createWithTrecho(trechoText, escritor: user, historia: historia!, createdAt: NSDate())
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{ println("falha em pegar criador") }
        }
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
                        println("salvando trecho \(trecho)")
                        novahistoria["trechos"] = [novoTrecho]
                        novahistoria.saveInBackgroundWithBlock{
                            (succeeded, error) in
                            if error == nil{
                                println("salvando historia no user")
                                let currentUser = PFUser.currentUser()!
                                if var historias = currentUser["historias"] as? [PFObject]{
                                    historias.append(novahistoria)
                                    currentUser["historias"] = historias
                                    currentUser.saveInBackgroundWithBlock{
                                        (succeeded, error) in
                                        if error == nil{
                                            Model.update()
                                        }
                                    }
                                }else{
                                    currentUser["historias"] = [novahistoria]
                                    currentUser.saveInBackgroundWithBlock{
                                        (succeeded, error) in
                                        if error == nil{
                                            Model.update()
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    class func saveUserWithParse(object:PFObject, completition: (Usuarios?) -> ()){
        
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
    
    class func parseObjectToDictionary(object:PFObject, ofType:ClassTypes) -> [ String : AnyObject ]{
        
        let historyAtribNames = ["titulo", "objectId", "trechoInicial", "createdAt", "criador", "favoritadas"]
        let userAtribNames = ["nome", "foto", "id", "historias", "seguindo", "seguido"]
        var dictionary = [String : AnyObject]()
        
        func historiaToDictionary(){
            
            for name in historyAtribNames{
                dictionary[name] = object[name]
            }
//            dictionary["titulo"] = object["titulo"] as? String
//            dictionary["objectId"] = object.objectId
//            dictionary["trechoInicial"] = object["trechoInicial"] as? String
//            dictionary["createdAt"] = object["createdAt"] as? NSDate
//            dictionary["criador"] = object["criador"]
//            dictionary["favoritadas"] = object["favoritadas"]
        }
        
        func usuarioToDictionary(){
            
            for name in userAtribNames{
                dictionary[name] = object[name]
            }
        }
        
        switch ofType{
            
        case .Historia:
            historiaToDictionary()
            
        case .Usuario:
            usuarioToDictionary()
        default:
            print("error")
        }
        return dictionary
    }
    
}
