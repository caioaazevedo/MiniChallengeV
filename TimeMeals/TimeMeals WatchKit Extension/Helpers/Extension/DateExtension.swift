//
//  DateExtension.swift
//  TimeMeals WatchKit Extension
//
//  Created by Luan Cabral on 14/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

extension Date{
    var time:Time{
        return Time(self)
    }
}
