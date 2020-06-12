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
    
    var reportDAO = ReportDAO()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let report = Report(uuid: UUID(), week: 1, totalRightTime: 10, totalWrongTime: 3, mostWrongTimeMeal: "café")
        
        reportDAO.create(report: report) { (result) in
            if result {
                print("criado")
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
    }
    
}
