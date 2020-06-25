//
//  ReportController.swift
//  TimeMeals WatchKit Extension
//
//  Created by Jonatas Coutinho de Faria on 17/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import WatchKit
import Foundation


class ReportController: WKInterfaceController  {
    
    //MARK: Outlets
    @IBOutlet weak var circleProgressScene: WKInterfaceSKScene!
    @IBOutlet weak var inconsistentMealLabel: WKInterfaceLabel!
    @IBOutlet weak var doneMealLabel: WKInterfaceLabel!
    @IBOutlet weak var missedMealLabel: WKInterfaceLabel!
    
    //MARK: Properties
    var scene: CircleProgressScene!
    let reportMetrics = ReportMetrics()
    
    //MARK: Life Cycle Methods
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let currentDevice = WKInterfaceDevice.current()
        let bounds = currentDevice.screenBounds
        
        // configure the circle progress scene
        scene = CircleProgressScene(size: CGSize(width: bounds.width, height: bounds.height))
        scene.scaleMode = .aspectFill
        
        circleProgressScene.presentScene(scene)
    }
    
    override func didAppear() {
        // get the report data
        
        reportMetrics.getAtualReport { (_) in
            
            scene.animateCircleProgress(percent: reportMetrics.rigthTimeMealsPercent())
            
            let rightTimes = reportMetrics.atualReport?.totalRightTime
            doneMealLabel.setText("\(rightTimes ?? 0) ")
            
            let wrongTimes = reportMetrics.atualReport?.totalWrongTime
            missedMealLabel.setText("\(wrongTimes ?? 0) ")
            
            reportMetrics.mostWrongTimeMeal { (mealText) in
                inconsistentMealLabel.setText(mealText)
            }
        }
    }
}

