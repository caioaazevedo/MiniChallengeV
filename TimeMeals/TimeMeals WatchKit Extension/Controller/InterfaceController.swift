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


class InterfaceController: WKInterfaceController  {
    
    //MARK: Outlets
    @IBOutlet weak var mealList: WKInterfaceTable!
    
    //MARK: Properties
    var mealsSchedule = [Meal]()
    
    //MARK: Life Cycle Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        self.fetchMealSchedule()
        self.setUpTable()
        for index in 0..<self.mealsSchedule.count {
            TimeValidator().defineMealStatus(oldMeal: self.mealsSchedule[index]) { (meal) in
                guard let mealStatus = meal else{return}
                self.mealsSchedule[index] = mealStatus
            }
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: Table Methods
    
    /// Set up table rows
    func setUpTable(){
        self.mealList.setNumberOfRows(self.mealsSchedule.count, withRowType: "MealRow")
        self.mealsSchedule.sort(by: {$0.time.time < $1.time.time})
        for rowIndex in 0..<self.mealsSchedule.count{
            guard let row = self.mealList.rowController(at: rowIndex) as? MealRowController else {continue}
            row.mealNameLabel.setText(self.mealsSchedule[rowIndex].title)
            row.hourLabel.setText(dateFormatter(date: self.mealsSchedule[rowIndex].time))
            row.delegate = self
            row.rowNumber = rowIndex
            self.verifyMealStatus(row: row)
            
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return self.mealsSchedule[rowIndex]
    }
    
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        return self.mealsSchedule
    }
    
    //MARK: Created Methods
    
    
    /// Verify the meal status and change the view
    /// - Parameter row: The row to change
    func verifyMealStatus(row: MealRowController){
        let currentMealStatus = self.mealsSchedule[row.rowNumber].status
        
        switch currentMealStatus {
        case .rightTime:
            row.buttonStatus.setBackgroundColor(.green)
        case .notTimeYet:
            row.buttonStatus.setBackgroundColor(.yellow)
        case .wrongTime:
            row.buttonStatus.setBackgroundColor(.red)
        }
    }
    
    
    
    /// Fetch the mels schedule from Core Data
    func fetchMealSchedule(){
        MealDAO.shared.retrieve { (meal) in
            guard let meal = meal else{return}
            self.mealsSchedule = meal
        }
    }
    
    
    /// Deffine a date format to HH:mm
    /// - Parameter date: Date to recive a  format
    /// - Returns: A string with date HH:mm format
    func dateFormatter(date:Date) -> String{
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return formater.string(from: date)
    }
}


//MARK: Row Button Clicked Protocol

extension InterfaceController: rowButtonClicked{
    
    /// Delegate called when the check button is clicked
    /// - Parameter index: waht specific row was checked
    func rowClicked(at index: Int) {
        
        // Only change status if the status has not yet changed
        if mealsSchedule[index].status == .notTimeYet {
            TimeValidator().defineMealStatus(oldMeal: mealsSchedule[index]) { (meal) in
                guard let meal = meal else {
                    print("error")
                    return
                }
                if meal.status == .rightTime{
                    WKInterfaceDevice.current().play(.success)
                }else if meal.status == .wrongTime{
                    WKInterfaceDevice.current().play(.failure)
                }
                
                
                ///Remove Standart Meal Notification
                print("Identifier: \(meal.uuid.uuidString)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [meal.uuid.uuidString])
                
                let delay = getTimeDiference(timeMeal: meal.time)
                
                /// Send notification after the old notification time scheduled
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    AppNotification().sendDynamicNotification(meal: meal)
                }
                
                mealsSchedule[index] = meal
                self.setUpTable()
            }
        }
    }
    
    /// Description: Get the difference of the dates based on their hour and minutes
    /// - Parameter timeMeal: the time of the meal to calculate the difference
    /// - Returns: the difference between the time of the meal and the current time
    func getTimeDiference(timeMeal: Date) -> Double{
        var mealComponents = DateComponents()
        var currentComponents = DateComponents()
        let calendar = Calendar.current
        
        /// Convert only the hour and minutes in Date
        mealComponents.hour = calendar.component(.hour, from: timeMeal)
        mealComponents.minute = calendar.component(.minute, from: timeMeal)
        
        currentComponents.hour = calendar.component(.hour, from: Date())
        currentComponents.minute = calendar.component(.minute, from: Date())
        
        let mealDate = calendar.date(from: mealComponents)!
        let currentDate = calendar.date(from: currentComponents)!
        
        return currentDate.distance(to: mealDate) + 60.0 // difference + 1 min
    }
}
