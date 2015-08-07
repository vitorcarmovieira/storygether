//
//  Usuarios.swift
//  StoryGether
//
//  Created by Vitor on 8/4/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import CoreData

@objc(Usuarios)
class Usuarios: NSManagedObject {

    @NSManaged var foto: NSData
    @NSManaged var id: String
    @NSManaged var nome: String
    @NSManaged var historias: NSSet
    @NSManaged var favoritas: NSSet
    @NSManaged var trechos: NSSet

    class func createWithName(nome: String, foto: NSData, id: String, historias: NSSet, trechos: NSSet, favoritas: NSSet) ->Usuarios{
        
        let usuario = NSEntityDescription.insertNewObjectForEntityForName("Usuarios") as! Usuarios
        
        usuario.nome = nome
        usuario.foto = foto
        usuario.id = id
        usuario.historias = historias
        usuario.trechos = trechos
        usuario.favoritas = favoritas
        
        saveOrUpdate()
        
        print("Usuario \(usuario) salvo.")
        return usuario
    }
    
    class func getCurrent() -> Usuarios?{
        var object: Usuarios?
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("user") as? NSData{
            if let url = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSURL{
                let per = (UIApplication.sharedApplication().delegate as! AppDelegate).persistentStoreCoordinator
                let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                
                let id = per?.managedObjectIDForURIRepresentation(url)
                object = moc?.objectWithID(id!) as? Usuarios
                
            }
        }
        return object
    }
}