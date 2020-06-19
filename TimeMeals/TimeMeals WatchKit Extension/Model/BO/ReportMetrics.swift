//
//  ReportMetrics.swift
//  TimeMeals WatchKit Extension
//
//  Created by Joao Paulo Pereira dos Santos on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

class ReportMetrics {
    
    var atualReport: Report?
    
    init () {
        
    }
    
    func getAtualReport(completion: (Bool)->Void) {
       
        ReportDAO.shared.retrieve { (reports) in
            guard var reports = reports else {
                completion(false)
                return
                
            }
            
            reports.sort { $0.week > $1.week }
            
            guard let atualReport = reports.first else {
                completion(false)
                return
                
            }
            
            self.atualReport = atualReport
            completion(true)
        }
    }
    
    func rigthTimeMealsPercent() -> Int {
        guard let report = self.atualReport else { return 0 }
        
        let totalMeals = report.totalRightTime + report.totalWrongTime
        if(totalMeals != 0){
            let percent = report.totalRightTime * 100 / totalMeals
            return percent
        }
        return 0
    }
    
    func wrongTimeMealsPercent() -> Int {
        guard let report = atualReport else { return 0 }
        
        let totalMeals = report.totalRightTime + report.totalWrongTime
            if(totalMeals != 0){
                let percent = report.totalWrongTime * 100 / totalMeals
                return percent
            }
        return 0
    }
    
func mostWrongTimeMeal(completion: (String) -> Void) {
        MealDAO.shared.retrieve { (allMeals) in
            guard let meals = allMeals else { return }
            
            let mostWrongTimeMeal = meals.max { a, b in a.wrongTimes < b.wrongTimes}
            
            if mostWrongTimeMeal?.wrongTimes == 0 {
                completion("None")
            } else {
                completion(mostWrongTimeMeal?.title ?? "None")
            }
        }
    }
}
