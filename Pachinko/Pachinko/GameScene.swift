//
//  GameScene.swift
//  Pachinko
//
//  Created by Alex Blanchard on 10/20/17.
//  Copyright © 2017 Alex Blanchard. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        buildScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.name = "ball"
            ball.size = CGSize(width: ball.size.width/1.65, height: ball.size.height/1.65)
            ball.position = location
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody!.restitution = 0.4
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            
            physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
            addChild(ball)
        }
    }
    
    //MARK: Scenc Builder
    
    func buildScene() {
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        makeSlot(at: CGPoint(x: 83, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 249, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 417, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 584, y: 0), isGood: false)
        
        var bouncerLocations = [CGPoint]()
        bouncerLocations = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 165, y: 0),
            CGPoint(x: 333, y: 0),
            CGPoint(x: 500, y: 0),
            CGPoint(x: 667, y: 0)
        ]
        
        for location in bouncerLocations {
            makeBouncer(at: location)
        }
    }
    
    //MARK: Scene building helper methods
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        }else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        
        slotGlow.position = position
        slotGlow.size = CGSize(width: slotGlow.size.width / 1.5, height: slotGlow.size.height / 1.5)
        addChild(slotGlow)
        
        slotBase.position = position
        slotBase.size = CGSize(width: slotBase.size.width / 1.4, height: slotBase.size.height / 1.4)
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        addChild(slotBase)
    }
    
    func makeBouncer(at position: CGPoint) {
        let b = SKSpriteNode(imageNamed: "bouncer")
        b.size = CGSize(width: b.size.width / 1.65, height: b.size.height / 1.65)
        b.physicsBody = SKPhysicsBody(circleOfRadius: b.size.width / 2.0)
        b.physicsBody?.isDynamic = false
        b.position = position
        addChild(b)
    }
    
    //MARK: Collision Detection & Handling
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        }else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
}
