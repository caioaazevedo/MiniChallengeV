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
        backgroundColor = .clear
        
        // set up the label
        labelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        labelNode.fontSize = self.size.width / 6
        labelNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.8 - labelNode.fontSize / 2.5)
        labelNode.fontColor = #colorLiteral(red: 0.3215686275, green: 0.5921568627, blue: 0.2470588235, alpha: 1)
        self.addChild(labelNode)
        
        // set up the main circle
        let path = UIBezierPath(arcCenter: .zero, radius: self.size.width / 3.5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        mainCircle = SKShapeNode(path: path.cgPath)
        mainCircle.fillColor = .clear
        mainCircle.lineWidth = 10
        mainCircle.lineCap = .round
        mainCircle.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.8)
        mainCircle.strokeColor = #colorLiteral(red: 0.3215686275, green: 0.5921568627, blue: 0.2470588235, alpha: 1)
        mainCircle.zPosition = 2
        mainCircle.isHidden = true
        self.addChild(mainCircle)
        
        // set up the background circle
        let backCircle = SKShapeNode(path: path.cgPath)
        backCircle.strokeColor = mainCircle.strokeColor
        backCircle.fillColor = mainCircle.fillColor
        backCircle.lineWidth = mainCircle.lineWidth
        backCircle.lineCap = mainCircle.lineCap
        backCircle.position = mainCircle.position
        backCircle.strokeColor = #colorLiteral(red: 0.862745098, green: 0.01176470588, blue: 0.2549019608, alpha: 1)
        backCircle.zPosition = 1
        self.addChild(backCircle)
        
        //set up fork and knife
        let fork = SKSpriteNode()
        fork.texture = SKTexture(imageNamed: "Fork")
        fork.position = CGPoint(x: self.size.width * 0.1, y: self.size.height / 1.8)
        fork.size = CGSize(width: self.size.width * 0.1, height: self.size.width * 0.45)
        self.addChild(fork)
        
        let knife = SKSpriteNode()
        knife.texture = SKTexture(imageNamed: "Knife")
        knife.position = CGPoint(x: self.size.width * 0.9, y: self.size.height / 1.8)
        knife.size = CGSize(width: self.size.width * 0.1, height: self.size.width * 0.45)
        self.addChild(knife)
        
        //set up leaf
        let leaf = SKSpriteNode()
        leaf.texture = SKTexture(imageNamed: "DishDetail")
        leaf.position = CGPoint(x: self.size.width / 2, y: self.size.height / 1.8 + self.size.width / 3.5 + mainCircle.lineWidth * 0.7)
        leaf.size = CGSize(width: self.size.height * 0.265, height: self.size.height * 0.11)
        leaf.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.addChild(leaf)
    }
    
    /// Get the current circle format for the animation
    /// - Parameter radius: the circle radius
    /// - Parameter withPercent: get the current percent of the circle
    private func getCirclePath(withPercent percent:CGFloat) -> CGPath {
        return  UIBezierPath(arcCenter: .zero, radius: self.size.width / 3.5 , startAngle: 2 * .pi * percent, endAngle: 0, clockwise: true).cgPath
    }
    
    /// Make the circle animation based on the percent
    /// - Parameter porcent: the maximum percent of the circle animation
    func animateCircleProgress(percent: Int)  {
        
        if percent == 0{
            self.labelNode.text = "0%"
            mainCircle.isHidden = true
            return
        }
        
        mainCircle.isHidden = false
        
        let duration = 4
        
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
