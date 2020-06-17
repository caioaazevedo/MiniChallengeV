//
//  ReportMetrics.swift
//  TimeMeals WatchKit Extension
//
//  Created by Joao Paulo Pereira dos Santos on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import Foundation

class ReportMetrics {
    
    func wrongTimeMealsNumber(completion: (Int)-> Void) {
        atualReport { (report) in
            completion(report.totalWrongTime)
        }
    }
    
    func rigthTimeMealsNumber(completion: (Int)-> Void) {
         atualReport { (report) in
            completion(report.totalRightTime)
        }
    }
    
    func rigthTimeMealsPercent(completion: (Int)-> Void) {
        atualReport { (report) in
            let totalMeals = report.totalRightTime + report.totalWrongTime
            if(totalMeals != 0){
                let percent = report.totalRightTime * 100 / totalMeals
                completion(percent)
            }
            completion(0)
        }
    }
    
    func wrongTimeMealsPercent(completion: (Int)-> Void) {
        atualReport { (report) in
            let totalMeals = report.totalRightTime + report.totalWrongTime
            if(totalMeals != 0){
                let percent = report.totalWrongTime * 100 / totalMeals
                completion(percent)
            }
            completion(0)
        }
    }
    
    func mostWrongTimeMeal(completion: (String?)-> Void) {
        atualReport { (report) in
            completion(report.mostWrongTimeMeal)
        }
    }
    
    func atualReport(completion: (Report)->Void) {
       
        ReportDAO.shared.retrieve { (reports) in
            guard var reports = reports else { return }
            reports.sort { $0.week > $1.week }
            guard let atualReport = reports.first else { return }
            completion(atualReport)
        }
    }
}
