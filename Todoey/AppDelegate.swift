//
//  AppDelegate.swift
//  Todoey
//
//  Created by AngelikaDW on 04/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //print Location of Realm file
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        //Prepares for the MIGRATION of the REALM DB when new properties are being added
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
        
        
        return true
    }
}


