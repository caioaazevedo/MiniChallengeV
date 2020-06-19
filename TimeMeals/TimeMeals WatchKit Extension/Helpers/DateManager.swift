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
        var myDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let calendar = Calendar.current
        var components = DateComponents()
        //Assign date components
        components.hour = hour
        components.minute = minute
        
        //Pass defined components from my date
        myDate =  calendar.date(bySettingHour: components.hour!, minute: components.minute!, second: 0, of: myDate!)
        return myDate ?? Date()
    }
    
    
    /// Verify if the choosed time  equals an existing one and enable or disable create button
    /// - Parameter date: New date  choosed on picker
    /// - Returns: Return if the date is valid or not
    func validTime(date:Date,mealList: [Meal]) -> Bool{
        var isValid = true
        
       for meal in mealList{
            if meal.time.time == date.time{
                return false
            }else if getDateDiff(start: meal.time, end: date) < -39  || getDateDiff(start: meal.time, end: date) > 39{
                isValid =  true
            }else{
                return  false
            }
        }
        
        return isValid
    }
    
    /// Compare both dates
    /// - Parameters:
    ///   - start: the starter date to compare
    ///   - end: the end date to compare
    /// - Returns: Difference between the dates in minutes
    func getDateDiff(start: Date, end: Date) -> Int  {
       let calendar = Calendar.current
       let timeComponents = calendar.dateComponents([.hour, .minute], from: start)
       let nowComponents = calendar.dateComponents([.hour, .minute], from: end)
        return  calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute!
    }
    
    
}
