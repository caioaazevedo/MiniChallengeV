//
//  DateManager.swift
//  TimeMeals WatchKit Extension
//
//  Created by Luan Cabral on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

class DateManager {
    ///Transform the hour and minute in Date
    /// - Parameters:
    ///   - hour: hour of meal
    ///   - minute: minute of meal
    /// - Returns: A date with dates components
    func setUpDate(hour:Int,minute:Int) -> Date{
        //Assign date components
        var dateCompenents = DateComponents()
        dateCompenents.hour = hour
        dateCompenents.minute = minute
        //Crate a date with components
        let deviceCalendar = Calendar.current
        let dateTime = deviceCalendar.date(from: dateCompenents)
        
        return dateTime ?? Date()
    }
}
