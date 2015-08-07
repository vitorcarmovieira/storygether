//
//  Trechos.swift
//  StoryGether
//
//  Created by Vitor on 8/4/15.
//  Copyright (c) 2015 BEPID. All rights reserved.
//

import Foundation
import CoreData

@objc(Trechos)
class Trechos: NSManagedObject {

    @NSManaged var createdAt: NSDate
    @NSManaged var trecho: String
    @NSManaged var escritor: Usuarios
    @NSManaged var historia: Historias

    class func createWithTrecho(trecho: String, escritor: Usuarios, historia: Historias, createdAt: NSDate) ->Trechos{
        
        let novoTrecho = NSEntityDescription.insertNewObjectForEntityForName("Trechos") as! Trechos
        
        novoTrecho.trecho = trecho
        novoTrecho.escritor = escritor
        novoTrecho.historia = historia
        novoTrecho.createdAt = createdAt
        
        saveOrUpdate()
        
        print("Usuario \(novoTrecho) salvo.")
        return novoTrecho
    }
}
