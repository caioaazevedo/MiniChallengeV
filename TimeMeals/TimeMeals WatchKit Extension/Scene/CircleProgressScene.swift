//
//  CircleProgressScene.swift
//  TimeMeals WatchKit Extension
//
//  Created by Jonatas Coutinho de Faria on 16/06/20.
//  Copyright © 2020 Caio Azevedo. All rights reserved.
//

import SpriteKit

class CircleProgressScene: SKScene {
    
    var labelNode: SKLabelNode!
    var mainCircle: SKShapeNode!
    
    override func sceneDidLoad() {
        setUpElements()
    }
    
    /// Set up all SpriteKit elements
    private func setUpElements() {
        
        // set the background scene color
        backgroundColor = .black
        
        // set up the label
        labelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        labelNode.fontSize = self.size.width / 6
        labelNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.7 - labelNode.fontSize / 2.5)
        self.addChild(labelNode)
        
        // set up the main circle
        let path = UIBezierPath(arcCenter: .zero, radius: self.size.width / 3, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        mainCircle = SKShapeNode(path: path.cgPath)
        mainCircle.strokeColor = .blue
        mainCircle.fillColor = .clear
        mainCircle.lineWidth = 10
        mainCircle.lineCap = .round
        mainCircle.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.7)
        mainCircle.zPosition = 2
        self.addChild(mainCircle)
        
        // set up the background circle
        let shapeNode2 = SKShapeNode(path: path.cgPath)
        shapeNode2.strokeColor = mainCircle.strokeColor
        shapeNode2.fillColor = mainCircle.fillColor
        shapeNode2.lineWidth = mainCircle.lineWidth
        shapeNode2.lineCap = mainCircle.lineCap
        shapeNode2.position = mainCircle.position
        shapeNode2.zPosition = 1
        shapeNode2.alpha = 0.4
        self.addChild(shapeNode2)
    }
    
    /// Get the current circle format for the animation
    /// - Parameter radius: the circle radius
    /// - Parameter withPercent: get the current percent of the circle
    private func getCirclePath(withPercent percent:CGFloat) -> CGPath {
        return  UIBezierPath(arcCenter: .zero, radius: self.size.width / 3 , startAngle: 2 * .pi * percent, endAngle: 0, clockwise: true).cgPath
    }
    
    /// Make the circle animation based on the percent
    /// - Parameter porcent: the maximum percent of the circle animation
    func animateCircleProgress(percent: Int)  {
        
        let duration = 5
        
        let animationAction = SKAction.customAction(withDuration: TimeInterval(duration)) { (node, elpasedTime) in
            
            let currentPercent =  elpasedTime/CGFloat(duration)
            
            if Int(currentPercent * 100) <= percent{
                (node as! SKShapeNode).path = self.getCirclePath(withPercent: -currentPercent)
                self.labelNode.text = "\(Int(currentPercent * 100))%"
            }
            
            node.zRotation = .pi / 2
        }
        
        mainCircle.run(animationAction)
    }
}
