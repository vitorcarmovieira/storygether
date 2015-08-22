//
//  Usuario.swift
//  StoryGether
//
//  Created by Vitor on 8/18/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import Parse

protocol UsuarioDelegate{
    func didChangeStories()
}

class Usuario{
    
    var delegate: UsuarioDelegate?
    
    private var pfuser: PFUser!
    private var historias: [Historia]
    private var historiasFav: [String]
    
    static let currentUser = Usuario()
    
    private init(){
        
        self.historias = []
        self.historiasFav = NSUserDefaults.standardUserDefaults().valueForKey("historiasFav") as? [String] ?? []
        self.pfuser = PFUser.currentUser()
        
        fetchFromLocalWithClassName{
            objects in
            self.historias = objects
            self.delegate?.didChangeStories()
        }
        
        fetchParseObjectsWithClassName{
            objects in
            self.historias = objects
            self.delegate?.didChangeStories()
        }
    }
    
    func getAllHistorias() -> [Historia]{
        return self.historias
    }
    
    func addFav(id: String){
        
        self.historiasFav.append(id)
        NSUserDefaults.standardUserDefaults().setValue(self.historiasFav, forKey: "historiasFav")
    }
    
    func hasUserFavThisStory(id: String) -> Bool{
        
        if contains(self.historiasFav, id){
            return true
        }
        return false
    }
    
    func parseToDictionary() -> [String : String]{
        
        var dictionary = [String : String]()
        
        dictionary["nome"] = self.pfuser["name"] as? String
        dictionary["urlFoto"] = self.pfuser["urlFoto"] as? String ?? ""
        
        return dictionary
    }
    
    private func fetchFromLocalWithClassName(completion: ([Historia]) -> ()){
        
        let className = "Historias"
        
        let predicate = NSPredicate(format: "criador == %@", self.pfuser)
        var query:PFQuery = PFQuery(className: className, predicate: predicate)
        query.fromPinWithName(className + self.pfuser.objectId!)
        query.orderByDescending("createdAt")
        
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
    
    private func fetchParseObjectsWithClassName(completion: ([Historia]) -> ()){
        
        let className = "Historias"
        
        let predicate = NSPredicate(format: "criador == %@", self.pfuser)
        var query:PFQuery = PFQuery(className: className, predicate: predicate)
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]?, error:NSError?)->Void in
            if error == nil{
                if let objects = objects as? [PFObject]{
                    PFObject.unpinAllObjectsInBackgroundWithName(className + self.pfuser.objectId!, block: {
                        (error) in
                        PFObject.pinAllInBackground(objects, withName: className + self.pfuser.objectId!)
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
