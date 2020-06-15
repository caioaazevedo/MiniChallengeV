//
//  MealRowController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Luan Cabral on 14/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit

protocol rowButtonClicked {
    func rowClicked(at index:Int)
}

class MealRowController: NSObject {
    @IBOutlet weak var buttonStatus: WKInterfaceButton!
    @IBOutlet weak var scheduleLabel: WKInterfaceLabel!
    
    var delegate: rowButtonClicked? = nil
    var rowNumber = 0
    
    
    @IBAction func buttonClicked() {
        self.delegate?.rowClicked(at: rowNumber)
    }
    
    
    
}
