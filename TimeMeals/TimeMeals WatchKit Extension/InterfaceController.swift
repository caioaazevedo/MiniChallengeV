//
//  InterfaceController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 10/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications

class InterfaceController: WKInterfaceController {
    
    var reportDAO = ReportDAO()
    var mealDAO = MealDAO()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                // Handle the error here.
                print(error)
            }
            
            // Enable or disable features based on the authorization.
            if granted {
                print("user authorized")
            }
        }
        
        let meal = Meal(uuid: UUID(), title: "Breakfast", time: Date(), status: .notTimeYet, wrongTimes: 0 )
        
        mealDAO.create(meal: meal) { (success) in
            if success {
                print("meal created")
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
    @IBAction func action() {
        reportDAO.retrieve { (results) in
            
            guard let results = results else { return }
            
            for result in results {
                print(result)
            }
        }
        
        mealDAO.retrieve { (meals) in
            guard let meals = meals else { return }
            
            for meal in meals {
                print(meal)
            }
        }
        
    }
}
