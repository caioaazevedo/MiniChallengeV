//
//  TimeValidator.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

class TimeValidator {
    
    /// Define meal time with current time and change status
    /// - Parameter meals: the meal to define the status
    /// - Parameter completion: return the updated meal or nil if update does not go well
    func defineMealStatus(oldMeal: Meal, completion: (Meal?) -> Void) {
        var meal = oldMeal
        let scheduleTime = meal.time
        let currentTime = Date()
        
        if scheduleTime.addingTimeInterval(30 * 60).time < currentTime.time ||
            scheduleTime.addingTimeInterval(-30 * 60).time > Date().time {
            // wrogn time
            meal.status = .wrongTime
            meal.wrongTimes += 1
        }else{
            // user got !
            meal.status = .rightTime
        }
        
        MealDAO().update(meal: meal) { (result) in
            if !result {
                completion(nil)
            }
            
            var reportsArray = [Report]()
            
            ReportDAO().retrieve { (reports) in
                
                guard let reports = reports else {
                    completion(nil)
                    return
                    
                }
                
                reportsArray = reports
                
                reportsArray.sort(by: {$0.week < $1.week})
                
                let index = reportsArray.count-1
                
                if meal.status == .rightTime {
                    reportsArray[index].totalRightTime += 1
                } else {
                    reportsArray[index].totalWrongTime += 1
                }
                
                ReportDAO().update(report: reportsArray[index]) { (result) in
                    if !result {
                        completion(nil)
                    }
                    
                    print("report updated")
                    completion(meal)
                }
            }
        }
    }
    
    /// Description: get the meal whose time is equal to the current time
    /// - Parameter completion: returne the searched meal by current time
    func searchMealByCurrentTime (completion: (Meal?) -> Void){
        let calendar = Calendar.current
        var componentsCurrent = DateComponents()
        componentsCurrent.hour = calendar.component(.hour, from: Date())
        componentsCurrent.minute = calendar.component(.minute, from: Date())
        
        MealDAO().retrieve { (meals) in
            meals?.forEach({ (meal) in
                var componentsMeal = DateComponents()
                
                componentsMeal.hour = calendar.component(.hour, from: meal.time)
                componentsMeal.minute = calendar.component(.minute, from: meal.time)
                
                guard let minutesMeals = componentsMeal.minute, let currentMinutes = componentsCurrent.minute else { return }
                
                let difference = minutesMeals - currentMinutes
                
                /// If the components are equals or the user had a delay of 5 min -> return the meal
                if componentsMeal == componentsCurrent ||  difference >= 5 || difference <= 5 {
                    completion(meal)
                }
            })
        }
    }
}
