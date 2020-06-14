//
//  InterfaceController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 10/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    //MARK: Outlets
    @IBOutlet weak var mealList: WKInterfaceTable!
    
    //MARK: Properties
    var mealsSchedule = [Meal]()
    
    //MARK: Life Cycle Methods
    override func awake(withContext context: Any?) {
        
        super.awake(withContext: context)
        self.fetchMealSchedule()
        self.setUpTable()
        
        
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    //MARK: Table Methods
    
    /// Set up table rows
    func setUpTable(){
        self.mealList.setNumberOfRows(self.mealsSchedule.count, withRowType: "MealRow")
        self.mealsSchedule.sort(by: {$0.time < $1.time})
        for rowIndex in 0..<self.mealsSchedule.count{
            guard let row = self.mealList.rowController(at: rowIndex) as? MealRowController else {continue}
            
            row.scheduleLabel.setText(dateFormatter(date: self.mealsSchedule[rowIndex].time))
            
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let meal = self.mealsSchedule[rowIndex]
        presentController(withName: "Settings", context: meal)
    }
    
    
    //MARK: Created Methods
    
    /// Fetch the mels schedule from Core Data
    func fetchMealSchedule(){
        self.mealsSchedule.append(Meal(uuid: UUID.init(), title: "Desjeju,", time: setUpDate(hour: 7, minute: 30), status: .notTimeYet, wrongTimes: 0))
        self.mealsSchedule.append(Meal(uuid: UUID.init(), title: "Café da Manhã", time: setUpDate(hour: 7, minute: 29), status: .notTimeYet, wrongTimes: 0))
        self.mealsSchedule.append(Meal(uuid: UUID.init(), title: "Desjeju,", time: setUpDate(hour: 6, minute: 0), status: .notTimeYet, wrongTimes: 0))
        
    }
    
    ///Transform the hour and minute in Date
    /// - Parameters:
    ///   - hour: hour of meal
    ///   - minute: minute of meal
    /// - Returns: A date with dates components
    func setUpDate(hour:Int,minute:Int) -> Date{
        //Assign date components
        var dateCompenents = DateComponents()
        dateCompenents.hour = hour
        dateCompenents.minute = minute
        
        //Crate a date with components
        let deviceCalendar = Calendar.current
        let dateTime = deviceCalendar.date(from: dateCompenents)
        
        return dateTime ?? Date()
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
