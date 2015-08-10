
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
    
    class func arrayObject(columnNameToSort: String, ascending: Bool = true, predicate: NSPredicate? = nil) -> [NSManagedObject] {
        var arrayManagedObject  = [NSManagedObject]()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: description())
        let sortDescriptor = NSSortDescriptor(key: columnNameToSort, ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]{
            arrayManagedObject = fetchResults
        }
        
        return arrayManagedObject
    }
    
    class func fetchedResultsController(columnNameToSort: String, ascending: Bool = true, predicate: NSPredicate? = nil) -> NSFetchedResultsController {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: description())
        fetchRequest.predicate = predicate
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
    
    class func hasValue(value: String, InColum: String) -> Usuarios?{
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let predicate = NSPredicate(format: "id == %@", value)
        let fetchRequest = NSFetchRequest(entityName: description())
        fetchRequest.predicate = predicate
        let count = (managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as! [Usuarios]).first
        println("encontrado: \(count)")
        
        return count
    }
    
    class func addObject(value: NSManagedObject, forKey: String) {
        self.willChangeValueForKey(forKey, withSetMutation: NSKeyValueSetMutationKind.UnionSetMutation, usingObjects: NSSet(object: value) as Set<NSObject>)
        var items = self.mutableSetValueForKey(forKey);
        println("mutable set \(items)")
        items.addObject(value)
        self.didChangeValueForKey(forKey, withSetMutation: NSKeyValueSetMutationKind.UnionSetMutation, usingObjects: NSSet(object: value) as Set<NSObject>)
    }
    
    class func updateColum(colum: String, to: AnyObject, withPredicate: NSPredicate? = nil){
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: description())
        batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.UpdatedObjectIDsResultType
        batchUpdateRequest.predicate = withPredicate
        batchUpdateRequest.propertiesToUpdate = [colum : to]
        
        var error: NSErrorPointer = nil
        let batchResult = managedObjectContext?.executeRequest(batchUpdateRequest, error: error) as! NSBatchUpdateResult
        println(" batch \(batchResult)")
        
        if error == nil{
            if let result: AnyObject = batchResult.result{
                println("resultado: \(result)")
            }else { println("nenhum resultado.") }
        }else { println("error em batch.") }
    }
}
