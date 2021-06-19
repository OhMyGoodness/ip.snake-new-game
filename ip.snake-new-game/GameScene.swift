//
//  GameScene.swift
//  ip.snake-new-game
//
//  Created by Данила Лазин on 18.06.2021.
//

import SpriteKit
import GameplayKit

struct CollisionCategories{
    static let Snake: UInt32 = 0x1 << 0     // 0001
    static let SnakeHead: UInt32 = 0x1 << 1 // 0010
    static let Apple: UInt32 = 0x1 << 2     // 0100
    static let EdgeBody: UInt32 = 0x1 << 3  // 1000
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var snake: Snake?
    var gameIsPaused:Bool = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        
        view.showsPhysics = true
        
        let counterClockwiseButton = SKShapeNode()
        counterClockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX+30, y: view.scene!.frame.minY + 30)
        counterClockwiseButton.fillColor = UIColor.gray
        counterClockwiseButton.strokeColor = UIColor.gray
        counterClockwiseButton.lineWidth = 10
        counterClockwiseButton.name = "counterClockwiseButton"
        
        let clockWiseButton = SKShapeNode()
        clockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        
        clockWiseButton.position = CGPoint(x: view.scene!.frame.maxX-80, y: view.scene!.frame.minY + 30)
        clockWiseButton.fillColor = UIColor.gray
        clockWiseButton.strokeColor = UIColor.gray
        clockWiseButton.lineWidth = 10
        clockWiseButton.name = "clockWiseButton"
        
        let pauseBtn = SKShapeNode()
        pauseBtn.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 120, height: 35)).cgPath
        pauseBtn.position = CGPoint(x: view.scene!.frame.midX-60, y: view.scene!.frame.minY + 35)
        pauseBtn.fillColor = UIColor.gray
        pauseBtn.strokeColor = UIColor.gray
        pauseBtn.lineWidth = 10
        pauseBtn.name = "pauseButton"
        
        self.addChild(counterClockwiseButton)
        self.addChild(clockWiseButton)
        self.addChild(pauseBtn)
        
        createApple()
        startNewGame()
        
//        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
//        self.addChild(snake!)
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name  == "counterClockwiseButton" || touchNode.name == "clockWiseButton" || touchNode.name == "pauseButton"
            else {
                return
            }
            
            touchNode.fillColor = .green
            
            if touchNode.name == "counterClockwiseButton"{
                snake!.moveCounterClockWise()
            } else if touchNode.name == "clockWiseButton" {
                snake!.moveClockWise()
            } else if touchNode.name == "pauseButton" {
                self.gameIsPaused = !gameIsPaused
                if (snake != nil){
                    snake!.togglePause()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name  == "counterClockwiseButton" || touchNode.name == "clockWiseButton" || touchNode.name == "pauseButton"
            else {
                return
            }
            
            touchNode.fillColor = .gray
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered()z
        
        if (self.gameIsPaused == false){
            snake!.move()
        }
    }
    
    func createApple(){
        
        var randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 40)))
        var randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 40)))
        
        if (randX <= 40) { randX = 40 }
        if (randY <= 40) { randY = 40 }
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        
        self.addChild(apple)
    }
    
    func startNewGame(){
        if (snake != nil){
            snake!.removeFromParent()
        }
        
        snake = Snake(atPoint: CGPoint(x: view!.scene!.frame.midX, y: view!.scene!.frame.midY))
        self.addChild(snake!)
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let bodies = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        let collisionObj = bodies - CollisionCategories.SnakeHead
        
        switch collisionObj {
            case CollisionCategories.Apple:
                let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
                
                snake?.addBodyPart()
                snake?.addBodyPart()
                
                apple?.removeFromParent()
                createApple()
        case CollisionCategories.EdgeBody:
            startNewGame()
            snake!.togglePause()
            
            self.gameIsPaused = true
    
            default:
                break
        }
    }
}
