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
        
        // configure the circle progress scene
        scene = CircleProgressScene(size: CGSize(width: 100, height: 100))
        scene.scaleMode = .aspectFit
        
        circleProgressScene.presentScene(scene)
        
        // get the report data
        reportMetrics.mostWrongTimeMeal(completion: { meal in
            inconsistentMealLabel.setText(meal)
        })
        
        reportMetrics.rigthTimeMealsPercent(completion: { percent in
            doneMealLabel.setText("\(percent)%")
        })
        
        reportMetrics.wrongTimeMealsPercent(completion: { percent in
            missedMealLabel.setText("\(percent)%")
        })
    }
    
    override func didAppear() {
        reportMetrics.rigthTimeMealsPercent(completion: { percent in
            scene.animateCircleProgress(percent: percent)
        })
    }
    
}

