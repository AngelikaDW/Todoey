//
//  Item.swift
//  Todoey
//
//  Created by AngelikaDW on 10/04/2018.
//  Copyright © 2018 aleaf. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //refers to reverse relationship to class Item, items = List<Item>
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
