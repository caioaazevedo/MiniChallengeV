//
//  MealEditController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Jonatas Coutinho de Faria on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit

class MealEditController: WKInterfaceController  {
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: WKInterfaceTextField!
    @IBOutlet weak var hourPicker: WKInterfacePicker!
    @IBOutlet weak var minutePicker: WKInterfacePicker!
    
    //MARK: Properties
    var currentMeal: Meal!
    
    //MARK: Life Cycle Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let meal = context as? Meal else {return}
        
        currentMeal = meal
        setUpPickers()
    }
    
    //MARK: Picker Methods
    
    /// Description: Set up pickers values
    func setUpPickers(){
        
        var hourOptions: [WKPickerItem] = []
        var minuteOptions: [WKPickerItem] = []
        
        titleTextField.setText(currentMeal.title)
        
        for i in 0...23{
            let item = WKPickerItem()
            item.title = i.timeFormat()
            hourOptions.append(item)
        }
        
        for i in 0...59{
            let item = WKPickerItem()
            item.title = i.timeFormat()
            minuteOptions.append(item)
        }
        
        hourPicker.setItems(hourOptions)
        minutePicker.setItems(minuteOptions)
        
        let currentHour = Calendar.current.component(.hour, from: currentMeal.time)
        let currentminute = Calendar.current.component(.minute, from: currentMeal.time)
        
        hourPicker.setSelectedItemIndex(currentHour)
        minutePicker.setSelectedItemIndex(currentminute)
    }
    
    //MARK: TextField Action Methods
    
    @IBAction func titleTextFieldAction(_ value: NSString?) {
        guard let text = value else {return}
        currentMeal.title = text as String
    }

    //MARK: Picker Action Methods
    
    @IBAction func hourPickerAction(_ value: Int) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let minute = calendar.component(.minute, from: currentMeal.time)
        
        currentMeal.time = calendar.date(bySettingHour: value, minute: minute, second: 0, of: currentMeal.time)!
    }
    
    @IBAction func minutePickerAction(_ value: Int) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let hour = calendar.component(.hour, from: currentMeal.time)
        
        currentMeal.time = calendar.date(bySettingHour: hour, minute: value, second: 0, of: currentMeal.time)!
    }
    
    //MARK: Buttons Action Methods

    @IBAction func saveButtonAction() {
        if(currentMeal.title.isEmpty){
            showAlertValidate()
        }else{
            showAlertChange()
        }
    }
    
    @IBAction func deleteButtonAction() {
        showAlertDelete()
    }
    
    //MARK: Validate and Alerts Functions
    
    /// Description: Show the validate alert
    func showAlertValidate(){
        
        let action = WKAlertAction(title: "Close", style: .default) {}
        
        presentAlert(withTitle: "Attention", message: "The meal title can not be empty.", preferredStyle: .actionSheet, actions: [action])
    }
    
    /// Description: Show the change meal alert
    func showAlertChange(){
        
        let action1 = WKAlertAction(title: "Change", style: .destructive) {
            let mealDAO = MealDAO()
            
            mealDAO.update(meal: self.currentMeal, completion: {_ in
                self.pop()
            })
        }
        
        let action2 = WKAlertAction(title: "Cancel", style: .default) {}
        
        presentAlert(withTitle: "Attention", message: "Are you sure you want to change this meal? The weekly report will be restarted.", preferredStyle: .actionSheet, actions: [action1,action2])
    }
    
    /// Description: Show the delete alert
    func showAlertDelete(){

        let action1 = WKAlertAction(title: "Delete", style: .destructive) {
            let mealDAO = MealDAO()
            
            mealDAO.delete(meal: self.currentMeal, completion: {_ in
                self.pop()
            })
        }
        
        let action2 = WKAlertAction(title: "Cancel", style: .cancel) {}

        presentAlert(withTitle: "Attention", message: "Are you sure you want to delete this meal? The weekly report will be restarted.", preferredStyle: .actionSheet, actions: [action1,action2])
    }
}
