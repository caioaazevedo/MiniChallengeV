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
    
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
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
        timeMealLabel.setText("07:00")
        titleMealLabel.setText("Breakfast")
    }
    
    @IBAction func markMeal() {
        print("Meal marked as done")
    }
    
    @IBAction func minDelayMeal() {
        
    }
    
    @IBAction func maxDelayMeal() {
        
    }
}
