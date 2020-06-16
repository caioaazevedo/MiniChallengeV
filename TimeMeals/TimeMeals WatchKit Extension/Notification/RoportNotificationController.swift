//
//  RoportNotificationController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Joao Paulo Pereira dos Santos on 16/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import UIKit
import WatchKit
import UserNotifications

class RoportNotificationController: WKUserNotificationInterfaceController {
    
    @IBOutlet weak var rightPercentLabel: WKInterfaceLabel!
    @IBOutlet weak var wrongPercentLabel: WKInterfaceLabel!
    
    var reportMetrics: ReportMetrics = ReportMetrics()
    
    override init() {
        super.init()
    }
    
    override func didReceive(_ notification: UNNotification) {
        
        reportMetrics.rigthTimeMealsPercent { (rigth) in
             rightPercentLabel.setText("wrong: \(rigth)%")
        }
       
        reportMetrics.wrongTimeMealsPercent { (wrong) in
            wrongPercentLabel.setText("wrong: \(wrong)%")
        }
    }
}
