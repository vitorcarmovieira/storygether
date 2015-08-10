//
//  Historias.swift
//  StoryGether
//
//  Created by Vitor on 8/4/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import CoreData

@objc(Historias)
class Historias: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var titulo: String
    @NSManaged var objectId: String
    @NSManaged var trechoInicial: String
    @NSManaged var criador: Usuarios
    @NSManaged var favoritada: Usuarios?
    @NSManaged var trechos: NSSet?

    class func createWithTitle(titulo: String, createdAt: NSDate, objectId: String, trechoInicial: String, criador: Usuarios,trechos: NSSet?, favoritada: Usuarios?) ->Historias?{
        
        let historia = NSEntityDescription.insertNewObjectForEntityForName("Historias") as! Historias
        
        historia.titulo = titulo
        historia.trechoInicial = trechoInicial
        historia.objectId = objectId
        historia.criador = criador
        historia.trechos = trechos
        historia.createdAt = createdAt
        historia.favoritada = favoritada
        
        saveOrUpdate()
        
        print("Historia \(historia) salvo.")
        return historia
    }
}
