//
//  SnakeHead.swift
//  ip.snake-new-game
//
//  Created by Данила Лазин on 18.06.2021.
//

import UIKit

class SnakeHead: SnakeBodyPart {
    
    override init(atPoint point: CGPoint, idx index: Int, diameter diameter: Int){
        super.init(atPoint: point, idx: index, diameter: 14)
        
        self.physicsBody?.categoryBitMask = CollisionCategories.SnakeHead
        
        self.physicsBody?.contactTestBitMask = CollisionCategories.Apple | CollisionCategories.EdgeBody | CollisionCategories.Snake | CollisionCategories.SnakeHead
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
