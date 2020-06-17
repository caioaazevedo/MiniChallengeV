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
        var myDate = Date()
        let calendar = Calendar.current
        var components = DateComponents()
        //Assign date components
        components.hour = hour
        components.minute = minute
        
        //Pass defined components from my date
        myDate =  calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: myDate)!
        
        return myDate
    }
    
    
    /// Verify if the choosed time  equals an existing one and enable or disable create button
    /// - Parameter date: New date  choosed on picker
    /// - Returns: Return if the date is valid or not
    func validTime(date:Date,mealList: [Meal]) -> Bool{
        var isValid = true
        mealList.forEach({ (meal) in
            if meal.time.time == date.time{
                isValid = false
            }
        })
        
        return isValid
    }
    
    
    
}
