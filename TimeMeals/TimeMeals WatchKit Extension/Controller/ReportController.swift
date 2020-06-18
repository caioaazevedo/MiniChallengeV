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

        scene.animateCircleProgress(percent: reportMetrics.rigthTimeMealsPercent())
        
        // get the report data
        
        reportMetrics.getAtualReport { (_) in
            let rightPercent = reportMetrics.rigthTimeMealsPercent()
            doneMealLabel.setText("\(rightPercent)%")
            
            let wrongPercent = reportMetrics.wrongTimeMealsPercent()
            missedMealLabel.setText("\(wrongPercent)%")
            
            reportMetrics.mostWrongTimeMeal { (mealText) in
                inconsistentMealLabel.setText(mealText)
            }
        }
    }
}

