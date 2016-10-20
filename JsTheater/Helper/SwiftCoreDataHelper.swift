//
//  SwiftCoreDataHelper.swift
//  ContactU
//


import UIKit
import CoreData

class SwiftCoreDataHelper: NSObject {
   
    class func directoryForDatabaseFilename()->NSString{
        return NSHomeDirectory() + "/Library/Private Documents"
    }
    

    class func databaseFilename()->NSString{
        return "database.sqlite";
    }
    
    
    class func managedObjectContext()->NSManagedObjectContext{

        var error:NSError? = nil

        do {
            try FileManager.default.createDirectory(atPath: SwiftCoreDataHelper.directoryForDatabaseFilename() as String, withIntermediateDirectories: true, attributes: [:])
        } catch {
            print(error)
        }

//        NSFileManager.defaultManager().createDirectoryAtPath(SwiftCoreDataHelper.directoryForDatabaseFilename(), withIntermediateDirectories: true, attributes: nil, error: &error)

        let path:NSString = "\(SwiftCoreDataHelper.directoryForDatabaseFilename()) + \(SwiftCoreDataHelper.databaseFilename())" as NSString
        
        let url:URL = URL(fileURLWithPath: path as String)
//        let url:NSURL = NSURL(fileURLWithPath: path)!
        
        let managedModel:NSManagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
        
        
        let storeCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
//        var storeCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            
        }

//        if storeCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error:&error ) != nil{
//            if error != nil{
//                println(error!.localizedDescription)
//                abort()
//            }
//        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        return managedObjectContext
        
    }
    
    func insertManagedObject(_ className:NSString, managedObjectConect:NSManagedObjectContext)->AnyObject{
//    class func insertManagedObject(className:NSString, managedObjectConect:NSManagedObjectContext)->AnyObject{
    
//        let managedObject:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectConect) as NSManagedObject
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: className as String, into: managedObjectConect) as NSManagedObject
        
        return managedObject
        
    }
    
    func saveManagedObjectContext(_ managedObjectContext:NSManagedObjectContext)->Bool{
        do{
            try managedObjectContext.save()
        } catch {
        }
        return true
    }

    

//    class func saveManagedObjectContext(managedObjectContext:NSManagedObjectContext)->Bool{
//        if managedObjectContext.save(nil){
//            return true
//        }else{
//            return false
//        }
//    }

    
    func fetchEntities(_ className:NSString, withPredicate predicate:NSPredicate?, managedObjectContext:NSManagedObjectContext)->NSArray{
        let items = [NSArray]()
        let fetchRequest:NSFetchRequest = NSFetchRequest()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entity(forEntityName: className as String, in: managedObjectContext)!
//    class func fetchEntities(className:NSString, withPredicate predicate:NSPredicate?, managedObjectContext:NSManagedObjectContext)->NSArray{
//        let fetchRequest:NSFetchRequest = NSFetchRequest()
//        let entetyDescription:NSEntityDescription = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)!

        fetchRequest.entity = entityDescription
        if predicate != nil{
            fetchRequest.predicate = predicate!
        }

        fetchRequest.returnsObjectsAsFaults = false
        do{
            _ = try managedObjectContext.fetch(fetchRequest)
            
        } catch {
        }
        return items as NSArray
    }

//        fetchRequest.entity = entetyDescription
//        if predicate != nil{
//            fetchRequest.predicate = predicate!
//        }
//        
//        fetchRequest.returnsObjectsAsFaults = false
//        let items:NSArray = managedObjectContext.executeFetchRequest(fetchRequest, error: nil)!
//        
//        return items
//    }
    
    
}
