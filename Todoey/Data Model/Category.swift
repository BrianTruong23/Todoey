//
//  Category.swift
//  Todoey
//
//  Created by MACBOOK on 7/6/18.
//  Copyright © 2018 Brian Truong. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}

