//
//  GameScene.swift
//  Ninja
//
//  Created by ALEX TIMMERMAN on 4/8/19.
//  Copyright © 2019 clc.timmerman. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None  :UInt32 = 0
    static let All  :UInt32 = UInt32.max
    static let monster  :UInt32 = 0b1
    static let projectile  :UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player = SKSpriteNode(imageNamed: "Ninja")
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
       var borders = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borders
       /* for i in 0...3{
            createMonster()
        }*/
        var counter = "Hello"
        var label = SKLabelNode(text: "Hello")
        label.position = CGPoint(x: 200, y: 100)
        addChild(label)
 run(SKAction.repeatForever(SKAction.sequence([SKAction.run(createMonster),SKAction.wait(forDuration: 0.2)])))
        createPlayer()
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    let backgroundMusic = SKAudioNode(fileNamed: "gameMusic")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }

    func createPlayer(){
        
        player.position = CGPoint(x: 50, y: 200)
        player.scale(to: CGSize(width: 75, height: 75))
        //player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 75, height: 75))
        //player.physicsBody?.affectedByGravity = false
        //player.physicsBody?.allowsRotation = false
        //player.physicsBody?.linearDamping = 1
        //player.physicsBody?.pinned = true
        addChild(player)
    }

   func createMonster(){
        var monster = SKSpriteNode(imageNamed: "enemy")

    monster.position = CGPoint(x: Int(frame.maxX), y: Int.random(in: 0...500))
        monster.scale(to: CGSize(width: 50, height: 50))
   monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 75, height: 75))
   monster.physicsBody?.affectedByGravity = false
    monster.physicsBody?.restitution = 1
    monster.physicsBody?.angularDamping = 0
    monster.physicsBody?.angularVelocity = 0
    monster.physicsBody?.friction = 0
   monster.physicsBody?.categoryBitMask = 3
    monster.physicsBody?.contactTestBitMask = 2
    addChild(monster)
    monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
    monster.physicsBody?.isDynamic = true
    monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
    monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
    monster.physicsBody?.collisionBitMask = PhysicsCategory.None
    /*monster.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 0))*/
    let actualDuration = CGFloat.random(in: 0.5...1.0)
    let actionMove = SKAction.move(to: CGPoint(x: 0, y: Int.random(in: 0...500)), duration: TimeInterval(actualDuration))
    let actionMoveDone = SKAction.removeFromParent()
    monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func createNinjaStar(){
        var ninjaStar = SKSpriteNode(imageNamed: "Ninja Star")
        ninjaStar.setScale(0.0000002)
        ninjaStar.position = randomPoint()
        ninjaStar.scale(to: CGSize(width: 5, height: 5))
        addChild(ninjaStar)
    }
   /* func spawnDrPhil() -> SKSpriteNode{
      let evilNinjas = SKSpriteNode(imageNamed: "Dr Phil")
        evilNinjas.position = CGPoint(x: Int(frame.maxX), y: Int.random(in: 0...500))
        evilNinjas.setScale(0.25)
        evilNinjas.physicsBody = SKPhysicsBody(rectangleOf: evilNinjas.size)
        evilNinjas.physicsBody?.affectedByGravity = false
        evilNinjas.physicsBody?.velocity = CGVector(dx: -325, dy: 0)
        return evilNinjas
        
        
        
    }
    override func update(_ currentTime: TimeInterval) {
        self.addChild(spawnDrPhil())
        if(children[0].position.x <= -10){
            children[0].removeFromParent()
        }
    }*/
    func randomPoint() -> CGPoint{
        var xpos = Int.random(in: 0...Int(self.size.width))
        var ypos = Int.random(in: 0...Int(self.size.height))
        return CGPoint(x: xpos, y: ypos)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        run(SKAction.playSoundFileNamed("pew.wav", waitForCompletion: false))
        let touchLocation = touch.location(in: self)
        let projectile = SKSpriteNode(imageNamed: "Ninja Star")
        projectile.setScale(0.05)
        projectile.position = player.position
   projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width)
        projectile.physicsBody?.categoryBitMask = 2
       
        addChild(projectile)
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        let offset = touchLocation - projectile.position
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    func projectileDidCollideWithMonster(nodeA: SKSpriteNode, NodeB: SKSpriteNode) {
        nodeA.removeFromParent()
        NodeB.removeFromParent()
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        if let monster = firstBody.node as? SKSpriteNode, let projectile = secondBody.node as? SKSpriteNode {
            projectileDidCollideWithMonster(nodeA: projectile, NodeB: monster)
        }
 var counter = "Hello"
        var label = SKLabelNode(text: String(counter))
    label.position = CGPoint(x: 200, y: 100)
   addChild(label)
    }
    

    
}

