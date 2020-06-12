//
//  Meal.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 12/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

struct Meal {
    var uuid: UUID
    var title: String
    var time: Date
    var status: MealStatus
    var wrongTimes: Int 
}
