//
//  Item+CoreDataProperties.swift
//  ARRuler
//
//  Created by Yigithan Narin on 10.05.2019.
//  Copyright © 2019 Yigithan Narin. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String

}
