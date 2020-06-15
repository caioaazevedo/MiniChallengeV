//
//  NotificationController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 10/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class NotificationController: WKUserNotificationInterfaceController {

    @IBOutlet weak var timeMealLabel: WKInterfaceLabel!
    @IBOutlet weak var titleMealLabel: WKInterfaceLabel!
    
    var meal: Meal?
    
    override init() {
        // Initialize variables here.
        super.init()
        meal = Meal(uuid: UUID(), title: "café", time: Date(), status: .notTimeYet, wrongTimes: 0)
        // Configure interface objects here.
        print("init")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("willActivate")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("didDeactivate")
    }

    override func didReceive(_ notification: UNNotification) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        
        timeMealLabel.setText("07:00")
        titleMealLabel.setText("Breakfast")
    }
    
    @IBAction func markMeal() {
        meal?.status = .rightTime
        
        MealDAO().update(meal: meal!) { (result) in
            if result {
                print("Meal marked as done")
            }
        }
        
        performDismissAction()
    }
    
    @IBAction func minDelayMeal() {
        print("15 minutes - min delay")
        
        // Scheduule a notifcation with 30 minutes delay
        AppNotification().sendNotifications(meal: meal!, delay: 15)
        
        performDismissAction()
    }
    
    @IBAction func maxDelayMeal() {
        print("30 minutes - min delay")
        
        // Scheduule a notifcation with 30 minutes delay
        AppNotification().sendNotifications(meal: meal!, delay: 30)
        
        performDismissAction()
    }
}
