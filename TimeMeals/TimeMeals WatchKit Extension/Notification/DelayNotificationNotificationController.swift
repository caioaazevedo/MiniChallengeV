//
//  DelayNotificationNotificationController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class DelayNotificationNotificationController: WKUserNotificationInterfaceController {
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    var meal: Meal?
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
        
        meal = Meal(uuid: UUID(), title: "café", time: Date(), status: .notTimeYet, wrongTimes: 0)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        
        timeLabel.setText("07:00")
        titleLabel.setText("Breakfast")
    }
    
    @IBAction func markAsDone() {
        meal?.status = .rightTime
        
        MealDAO().update(meal: meal!) { (result) in
            if result {
                print("Meal marked as done")
            }
        }
        
        var reportsArray = [Report]()
        
        ReportDAO().retrieve { (reports) in
            
            guard let reports = reports else {return}
            reportsArray = reports
        }
        
        reportsArray.sort(by: {$0.week < $1.week})
        
        let index = reportsArray.count-1
        
        reportsArray[index].totalRightTime += 1
        
        ReportDAO().update(report: reportsArray[index]) { (result) in
            print("report updated")
        }
        
        performDismissAction()
    }
}
