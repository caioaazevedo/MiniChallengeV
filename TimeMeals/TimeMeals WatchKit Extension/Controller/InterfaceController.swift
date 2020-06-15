//
//  InterfaceController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Caio Azevedo on 10/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController  {
    
    //MARK: Outlets
    @IBOutlet weak var mealList: WKInterfaceTable!
    
    //MARK: Properties
    var mealsSchedule = [Meal]()
    var mealDAO = MealDAO()
    
    //MARK: Life Cycle Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        self.fetchMealSchedule()
        self.setUpTable()
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
        self.mealDAO.retrieve { (meal) in
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
        TimeValidator().defineMealStatus(oldMeal: mealsSchedule[index]) { (meal) in
            guard let meal = meal else {
                print("error")
                return
            }
            
            mealsSchedule[index] = meal
            self.setUpTable()
        }
        
    }
}
