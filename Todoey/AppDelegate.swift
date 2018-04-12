//
//  AppDelegate.swift
//  Todoey
//
//  Created by AngelikaDW on 04/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //print Location of Realm file
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //Prepares for the Migration of the REALM DB when new properties are being added
        let config = Realm.Configuration(
            
            schemaVersion: 1,
            
            migrationBlock: { migration, oldSchemaVersion in
                
                if (oldSchemaVersion < 1) {
                    
                    migration.enumerateObjects(ofType: Category.className()) { (old, new) in
                        new!["dateCreated"] = Date()
                    }
                    migration.enumerateObjects(ofType: Item.className()) { (old, new) in
                        new!["dateCreated"] = Date()
                    }
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        
//        do {
//             let realm = try Realm()
//        } catch  {
//            print("error in initialising new realm, \(error)")
//        }
        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

