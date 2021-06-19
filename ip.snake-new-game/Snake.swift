//
//  Snake.swift
//  ip.snake-new-game
//
//  Created by Данила Лазин on 18.06.2021.
//

import UIKit
import SpriteKit

class Snake: SKShapeNode{
    var body = [SnakeBodyPart]()
    
    let moveSpeed: CGFloat = 125.0
    var angle: CGFloat = 0.0
    
    convenience init(atPoint point: CGPoint) {
        self.init()
        
        let head = SnakeHead(atPoint: point, idx: 0, diameter: 10)
        body.append(head)
        addChild(head)
    }
    
    func togglePause(){
        isPaused = !isPaused
    }
    
    func addBodyPart(){
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x, y: body[0].position.y), idx: body.count)
        //body.append(newBodyPart)
        body.insert(newBodyPart, at: 1)
        
        addChild(newBodyPart)
    }
    
    func move(){
        guard !body.isEmpty else { return }
        
        let head = body[0]
        moveHead(head)
        
        var offset:CGFloat = CGFloat(head.currentDiameter) / 2
        for index in (0..<body.count) where index > 0{
            let prevBodyPart = body[index - 1]
            let curBodyPart = body[index]
            
            if (index != 1){
                offset = 0.0
            }
            moveBodyPart(prevBodyPart, curBodyPart, offset)
        }
    }
    
    func moveHead(_ head: SnakeBodyPart){
        let dx = moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        head.run(moveAction)
    }
    
    func moveBodyPart(_ fromPart: SnakeBodyPart, _ targetPart: SnakeBodyPart, _ offset: CGFloat) {
        var newOffset:CGFloat = 0.0
        if (offset != 0.0){
            newOffset = offset / 2 - (CGFloat(targetPart.currentDiameter) / 2)
        }
        let moveAction = SKAction.move(to: CGPoint(x: fromPart.position.x - newOffset, y: fromPart.position.y - newOffset), duration: 0.1)
        targetPart.run(moveAction)
    }
    
    func moveClockWise() {
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveCounterClockWise(){
        angle -= CGFloat(Double.pi / 2)
    }
}
