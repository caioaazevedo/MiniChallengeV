//
//  ReportCD+CoreDataProperties.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 12/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//
//

import Foundation
import CoreData


extension ReportCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReportCD> {
        return NSFetchRequest<ReportCD>(entityName: "ReportCD")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var week: Int32
    @NSManaged public var totalRightTime: Int32
    @NSManaged public var totalWrongTime: Int32
    @NSManaged public var mostWrongTimeMeal: String?

}
