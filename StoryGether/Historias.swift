//
//  Historias.swift
//  StoryGether
//
//  Created by Vitor on 8/1/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import CoreData

@objc(Historias)
class Historias: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var objectId: String
    @NSManaged var titulo: String
    @NSManaged var trechoInicial: String
    @NSManaged var criador: Usuarios
    @NSManaged var favoritadas: NSSet
    
    class func createWithTitle(titulo: String, objectId: String, createdAt: NSDate, trechoInicial: String, criador: Usuarios, favoritadas: NSSet) ->Historias?{
        
        let historia = NSEntityDescription.insertNewObjectForEntityForName("Historias") as! Historias
        
        historia.objectId = objectId
        historia.titulo = titulo
        historia.trechoInicial = trechoInicial
        historia.criador = criador
        historia.favoritadas = favoritadas
        
        saveOrUpdate()
        
        print("Historia \(historia) salvo.")
        return historia
    }

}
