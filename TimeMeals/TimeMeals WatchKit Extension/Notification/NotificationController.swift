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
        // Configure interface objects here.
        
        TimeValidator().searchMealByCurrentTime { (meal) in
            if meal != nil {
                self.meal = meal
            }
        }
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
        
        let dateFormated = AppNotification().dateFormated(date: meal?.time ?? Date())
        
        timeMealLabel.setText(dateFormated)
        titleMealLabel.setText(meal?.title ?? "Meal")
    }
    
    @IBAction func markMeal() {
        
        TimeValidator().defineMealStatus(oldMeal: meal!) { (resultMeal) in
            if resultMeal == nil  {
                print("Error when update meal`s status on Notification")
            } else {
                print("Meal marked as done")
                WKInterfaceDevice.current().play(.success)
            }
            performDismissAction()
        }
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
