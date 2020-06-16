//
//  MealCreateController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Jonatas Coutinho de Faria on 15/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit

class MealCreateController: WKInterfaceController {
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: WKInterfaceTextField!
    @IBOutlet weak var hourPicker: WKInterfacePicker!
    @IBOutlet weak var minutePicker: WKInterfacePicker!
    
    //MARK: Properties
    var newMeal: Meal!
    
    override init() {
        let initialTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        
        self.newMeal = Meal(uuid: UUID.init(), title: "", time: initialTime!, status: .notTimeYet, wrongTimes: 0)
    }
    
    //MARK: Life Cycle Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setUpPickers()
    }
    
    //MARK: Picker Methods
    
    /// Description: Set up pickers values
    func setUpPickers(){
        
        var hourOptions: [WKPickerItem] = []
        var minuteOptions: [WKPickerItem] = []
        
        titleTextField.setText(newMeal.title)
        
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
        
        let currentHour = Calendar.current.component(.hour, from: newMeal.time)
        let currentminute = Calendar.current.component(.minute, from: newMeal.time)
        
        hourPicker.setSelectedItemIndex(currentHour)
        minutePicker.setSelectedItemIndex(currentminute)
    }
    
    //MARK: TextField Action Methods
    
    @IBAction func titleTextFieldAction(_ value: NSString?) {
        guard let text = value else {return}
        newMeal.title = text as String
    }

    //MARK: Picker Action Methods
    
    @IBAction func hourPickerAction(_ value: Int) {
        let calendar = Calendar.current
        var components = DateComponents()
        
        components.hour = value
        let minute = calendar.component(.minute, from: newMeal.time)
        
        newMeal.time = calendar.date(bySettingHour: components.hour!, minute: minute, second: 0, of: newMeal.time)!
    }
    
    @IBAction func minutePickerAction(_ value: Int) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let hour = calendar.component(.hour, from: newMeal.time)
        
        newMeal.time = calendar.date(bySettingHour: hour, minute: value, second: 0, of: newMeal.time)!
    }
    
    //MARK: Buttons Action Methods

    @IBAction func createButtonAction() {
        if(newMeal.title.isEmpty){
            showAlertValidate()
        }else{
            let mealDAO = MealDAO()
            mealDAO.create(meal: newMeal, completion: {bool in
                AppNotification().sendDynamicNotification(meal: newMeal)
                pop()
            })
        }
    }
    
    /// Description: Show the validate alert
    func showAlertValidate(){
        
        let action = WKAlertAction(title: "Close", style: .default) {}
        
        presentAlert(withTitle: "Attention", message: "The meal title can not be empty.", preferredStyle: .actionSheet, actions: [action])
    }
}
