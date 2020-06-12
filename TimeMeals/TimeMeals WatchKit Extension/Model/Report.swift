//
//  Report.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 12/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

struct Report {
    //MARK:- Atributes
    var uuid: UUID
    var week: Int
    var totalRightTime: Int
    var totalWrongTime: Int
    var mostWrongTimeMeal: String
}
