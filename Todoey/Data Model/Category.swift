//
//  Category.swift
//  Todoey
//
//  Created by AngelikaDW on 10/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // inside each Category is a List pointing to the list forward relationship
    let items = List<Item>() //initialize an empty List of Item Object
    
    
}