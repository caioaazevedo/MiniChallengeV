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
        TimeValidator().defineMealStatus(oldMeal: meal!) { (resultMeal) in
            if resultMeal == nil  {
                print("Error when update meal`s status on Notification")
            } else {
                print("Meal marked as done")
            }
            performDismissAction()
        }
    }
}
