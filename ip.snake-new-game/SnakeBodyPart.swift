//
//  SnakeBodyPart.swift
//  ip.snake-new-game
//
//  Created by Данила Лазин on 18.06.2021.
//

import UIKit
import SpriteKit

class SnakeBodyPart: SKShapeNode{
    var currentDiameter: Int = 10
    var bodyIndex: Int = 0
    
    init(atPoint point: CGPoint, idx index: Int, diameter: Int = 10){
        super.init()
        self.bodyIndex = index
        
        currentDiameter = diameter
        
        path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: diameter, height: diameter)).cgPath
        fillColor = .green
        strokeColor = .green
        lineWidth = 5
        
        self.position = point
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(currentDiameter - 4), center: CGPoint(x: 5, y: 5))
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Snake
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

