
//
//  DAO.swift
//  Swift2_Aula_1
//
//  Created by Wendel Silva on 13/07/15.
//  Copyright © 2015 BEPiD. All rights reserved.
//

import UIKit
import CoreData

extension NSEntityDescription {
    
    class func insertNewObjectForEntityForName(entityName: String) -> NSManagedObject{
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        return self.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext!) as! NSManagedObject
    }
}

extension NSManagedObject {
    
    class func saveOrUpdate() -> Bool {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var error: NSError? = nil
        if let moc = managedObjectContext{
            moc.save(&error)
            if error == nil{
                return true
            }
        }
        return false
    }
    
    class func deleteObject(object: NSManagedObject) -> Bool {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        var error: NSError? = nil
        if let moc = managedObjectContext{
            moc.deleteObject(object)
            moc.save(&error)
            if error == nil{
                return true
            }
        }
        return false
    }
    
    class func arrayObject(columnNameToSort: String) -> [NSManagedObject] {
        var arrayManagedObject  = [NSManagedObject]()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: description())
        let sortDescriptor = NSSortDescriptor(key: columnNameToSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]{
            arrayManagedObject = fetchResults
        }
        
        return arrayManagedObject
    }
    
    class func fetchedResultsController(columnNameToSort: String, ascending: Bool = true) -> NSFetchedResultsController {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: description())
        let sortDescriptor = NSSortDescriptor(key: columnNameToSort, ascending: ascending)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    class func countObjects() -> Int?{
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: description())
        let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: nil)
        
        return count
    }
}
