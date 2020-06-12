//
//  MealCD+CoreDataProperties.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 12/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//
//

import Foundation
import CoreData


extension MealCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealCD> {
        return NSFetchRequest<MealCD>(entityName: "MealCD")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var title: String?
    @NSManaged public var time: Date?
    @NSManaged public var status: Data?
    @NSManaged public var wrongTimes: Int32

}
