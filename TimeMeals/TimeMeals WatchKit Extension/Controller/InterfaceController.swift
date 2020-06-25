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
        self.refreshData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK: IBACTIONS
    
    /// The menu button that apply the default schedule
    @IBAction func defaultMeal() {
        self.createDefaultMeal()
        self.refreshData()
    }
    
    
    /// The menu button that clear all meals in table
    @IBAction func clearMeals() {
        self.deleteAllMels()
        self.refreshData()
    }
    
    
    //MARK: Table Methods
    
    /// Refresh the data of core data
    func refreshData(){
        self.fetchMealSchedule()
        self.setUpStatusOnTable()
        self.setUpTable()
    }
    
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
    
    
    func setUpStatusOnTable(){
        for index in 0..<self.mealsSchedule.count {
            
            if self.mealsSchedule[index].status == .wrongTime{continue}
            if self.mealsSchedule[index].time.addingTimeInterval(30 * 60).time < Date().time{
                //wrong time
                self.mealsSchedule[index].status = .wrongTime
                self.mealsSchedule[index].wrongTimes += 1
                MealDAO.shared.update(meal:  self.mealsSchedule[index]) { _ in
                    return
                }
                
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        return self.mealsSchedule[rowIndex]
    }
    
    
    /// Description: creates and initializes the standard diet for the user to follow
    func createDefaultMeal(){
        var sameMeal = 0
        let currentDate = Date()
        let date = DateManager()
        var defaultMeals = [Meal(uuid: UUID.init(), title: "Desjejum", time: date.setUpDate(hour: 7, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Breakfast", time: date.setUpDate(hour: 11, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Lunch", time: date.setUpDate(hour: 13, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Snack", time: date.setUpDate(hour: 17, minute: 0), status: .notTimeYet, wrongTimes: 0),
                            Meal(uuid: UUID.init(), title: "Dinner", time: date.setUpDate(hour: 20, minute: 0), status: .notTimeYet, wrongTimes: 0)
        ]
        
        self.mealsSchedule.forEach { (meal) in
            for defaultMeal in defaultMeals{
                if meal.title == defaultMeal.title && meal.time.time == defaultMeal.time.time {
                    sameMeal += 1
                }
            }
        }
        
        if sameMeal >= defaultMeals.count{
            return
        }
        self.clearMeals()
        
        for index in 0..<defaultMeals.count{
            if defaultMeals[index].time.addingTimeInterval(30 * 60) < currentDate{
                defaultMeals[index].status = .wrongTime
            }
            MealDAO.shared.create(meal: defaultMeals[index]) { _ in
                AppNotification().sendDynamicNotification(meal: defaultMeals[index])
                return
            }
        }
        resetWeekReportAction()
    }

    /// Delete all list of meals
    func deleteAllMels(){
        if self.mealsSchedule.isEmpty {return}
        self.mealsSchedule.forEach { (meal) in
            MealDAO.shared.delete(meal: meal, completion: {_ in return})
            AppNotification().removeNotification(identifier: meal.uuid.uuidString)
        }
        
        resetWeekReportAction()
    }
    
    /// Description: Reset the week report
    /// - Returns: A WKAlertAction to delete the week report
    func resetWeekReportAction(){
        
        //Reset the week
        let reportMetrics = ReportMetrics()
        
        reportMetrics.getAtualReport(completion: { _ in
            
            guard let report = reportMetrics.atualReport else { return }
            
            let newReport = Report(uuid: UUID(), week: report.week+1, totalRightTime: 0, totalWrongTime: 0, mostWrongTimeMeal: "None")
            
            // Create new report in Core Data
            ReportDAO.shared.create(report: newReport) { _ in
                // Remove pending notification from old report
                AppNotification().notificationCenter.removePendingNotificationRequests(withIdentifiers: [report.uuid.uuidString])
                //Create notification from new report
                AppNotification().sendReportNotification(report: newReport)
            }
        })
    }
    
    //MARK: Created Methods
    
    /// Verify the meal status and change the view
    /// - Parameter row: The row to change
    func verifyMealStatus(row: MealRowController){
        let currentMealStatus = self.mealsSchedule[row.rowNumber].status
        
        switch currentMealStatus {
        case .rightTime:
            row.buttonStatus.setBackgroundImageNamed("CorrectMeal")
            row.statusLabel.setTextColor(UIColor(red: 0.34, green: 0.65, blue: 0.33, alpha: 1.00))
            row.statusLabel.setText("Done")
        case .notTimeYet:
            row.buttonStatus.setBackgroundImageNamed("NotDoneMeal")
            row.statusLabel.setTextColor(UIColor(red: 0.95, green: 0.49, blue: 0.03, alpha: 1.00))
            row.statusLabel.setText("Coming")
        case .wrongTime:
            row.buttonStatus.setBackgroundImageNamed("IncorrectMeal")
            row.statusLabel.setTextColor(UIColor(red: 0.86, green: 0.01, blue: 0.25, alpha: 1.00))
            row.statusLabel.setText("Missed")
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
                
                /// 'Delete' delay value by returnig the value to nil
                AppUtilsDAO.shared.saveAppUtils(expectedTimeDelay: nil) { _ in
                    print("expectedTimeDelay was deleted")
                }
                
                let delay = getTimeDiference(timeMeal: meal.time)
                
                print("delay: \(delay)")
                
                /// Send notification after the old notification time scheduled
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    AppUtilsDAO.shared.saveAppUtils(expectedTimeDelay: Date().addingTimeInterval(delay)) { (result) in
                        print("Delay Saved")
                    }
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
