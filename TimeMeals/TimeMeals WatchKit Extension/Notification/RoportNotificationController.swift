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
    var report: Report?
    
    override init() {
        super.init()
        
        reportMetrics.getAtualReport { _ in
            report = reportMetrics.atualReport!
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        guard let report = report else { return }
        
        let newReport = Report(uuid: UUID(), week: report.week+1, totalRightTime: 0, totalWrongTime: 0, mostWrongTimeMeal: "None")
        
        ReportDAO.shared.create(report: newReport) { _ in
            AppNotification().notificationCenter.removePendingNotificationRequests(withIdentifiers: [report.uuid.uuidString])
            AppNotification().sendReportNotification(report: newReport)
        }
    }
    
    override func didReceive(_ notification: UNNotification) {
        
        guard let report = report else { return }
        
        rightPercentLabel.setText("right: \(report.totalRightTime)%")

        wrongPercentLabel.setText("wrong: \(report.totalWrongTime)%")
    }
}
