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
    
    class func hasNewHistory(completion: (bool: Bool) -> ()){
        
        var query:PFQuery = PFQuery(className: "Historias")
        query.countObjectsInBackgroundWithBlock{
            (count:Int32, error:NSError?)->Void in
            
            if error == nil{
                if let numberLocalObjects = Historias.countObjects(){
                    completion(bool: count == Int32(numberLocalObjects))
                }
            }
        }
    }
    
    class func fetchParseObjectsWithClassName(className:String, predicate:NSPredicate = NSPredicate(format: "objectId != %@", "123"), completionHandler: (array: [PFObject]?) -> ()){
        
        var query:PFQuery = PFQuery(className: "Historias", predicate: predicate)
        query.orderByDescending("createdAt")
        query.includeKey("criador")
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            if error == nil{
                if let objects = objects as? [PFObject]{
                    completionHandler(array: objects)
                    print("\(objects)")
//                    self.saveInLocalObjects(objects)
                }
            }
        }
    }
    
    class func saveInLocalObjects(objects:[PFObject]){
        
//        for object in objects{
//            let dictionary = parseObjectToDictionary(object, ofType: .Historia)
//            let profile: AnyObject? = dictionary["criador"]
//            let nome = profile!.valueForKey("name") as? String
////            let urlFoto = profile.valueForKey("urlFoto") as? String
////            let image = getImageAssync(urlFoto)
////            let imageData = UIImageJPEGRepresentation(image, 0.7)
//            let id = profile.valueForKey("id") as? String
//            let user = Usuarios.createWithName(nome!, foto: NSData(), id: id!, historias: NSSet(), seguindo: NSSet(), seguido: NSSet())
//            let historia = Historias.createWithTitle(dictionary["titulo"] as! String, objectId: object.objectId!, createdAt: object.createdAt!, trechoInicial: dictionary["trechoInicial"] as! String, criador: user, favoritadas: NSSet())
//        }
    }
    
    class func saveParseObjectHistory(titulo: String, trecho: String){
        
        let className = PFUser.currentUser()?.parseClassName
        
        var trechoInicial: PFObject = PFObject(className: "Trechos")
        trechoInicial["trecho"] = trecho
        trechoInicial["escritor"] = PFUser.currentUser()!
        
        var novahistoria:PFObject = PFObject(className: "Historias")
        novahistoria["titulo"] = titulo
        novahistoria["criador"] = PFUser.currentUser()
        novahistoria["trechoInicial"] = trecho
        
        let user = PFUser.currentUser()!
        if var historias = user["historias"] as? [PFObject]{
            
            historias.append(novahistoria)
            user["historias"] = historias
        } else { user["historias"] = [novahistoria] }
        
        user.saveInBackgroundWithBlock({
            (sucess, error) -> Void in
            if error != nil {
                // There was an error.
                print("erro em salvar historia.")
            }else {
                print("historia salva. \(sucess)")
                
                trechoInicial["historia"] = novahistoria
                trechoInicial.saveInBackgroundWithBlock{
                    (sucess, error) in
                    if error != nil{
                        print("erro em salvar trecho")
                    }else {
                        print("trecho salvo. \(sucess)")
                        if let currentUser = Usuarios.getCurrent(){
                            if let historia = Historias.createWithTitle(titulo, objectId: novahistoria.objectId!, createdAt: NSDate(), trechoInicial: trecho, criador: currentUser, favoritadas: NSSet()){
                                currentUser.addObject(historia, forKey: "historias")
                                print("\(currentUser.historias)")
                                Usuarios.saveOrUpdate()
                            }
                        }
                    }
                }
            }
        })
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
