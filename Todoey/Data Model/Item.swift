//
//  Item.swift
//  Todoey
//
//  Created by MACBOOK on 7/6/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object {
  @objc dynamic  var title : String = ""
   @objc  var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
