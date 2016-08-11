//
//  WorldScene.swift
//  FlappyBird
//
//  Created by Nikita Belousov on 6/4/16.
//  Copyright © 2016 Nikitab Belousov. All rights reserved.
//

import UIKit

class WorldScene: SKScene {
    
    private var groundForeverMoveAction: SKAction!
    private var nearBackground: SKNode!
    private var mediumBackground: SKNode!
    private var farBackground: SKNode!
    
    override func didMoveToView(view: SKView) {
        createPreloadedResources()
        nearBackground = runningNode("backgroundNear", zPosition: -10, speed: 500, definesPhysicalObject: true)
        nearBackground.name = "backgroundNear"
        mediumBackground = runningNode("backgroundMedium", zPosition: -20,  speed: 70)
        mediumBackground.name = "backgroundMedium"
        mediumBackground.alpha = 0.7
        farBackground = runningNode("backgroundFar", zPosition: -30, speed: 30)
        farBackground.name = "backgroundFar"
        addChild(nearBackground)
        addChild(mediumBackground)
        addChild(farBackground)
    }
    
    func runningNode(imageName: String, zPosition: CGFloat, speed: CGFloat, definesPhysicalObject: Bool = false) -> SKNode {
        
        let numberOfRepeats = 2
        
        let node = SKNode()
        node.name = imageName
        
        let texture = SKTexture(imageNamed: imageName)
        let width = texture.size().width
        let height = texture.size().height
        
        for i in 0 ..< numberOfRepeats {
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = CGPoint(x: width/2 + CGFloat(i) * (width - 3), y: height/2)
            sprite.zPosition = zPosition
            
            if definesPhysicalObject {
                sprite.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
                sprite.physicsBody?.dynamic = false
                sprite.physicsBody?.contactTestBitMask = sprite.physicsBody!.collisionBitMask
            }
            node.addChild(sprite)
        }
        
        let duration = Double(width / speed)
        let moveAction = SKAction.moveBy(CGVector(dx: -width, dy: 0) , duration: duration)
        let resetAction = SKAction.runBlock({
            node.position = CGPointZero
        })
        let foreverAction = SKAction.repeatActionForever(SKAction.sequence([moveAction, resetAction]))
        node.runAction(foreverAction)
        
        groundForeverMoveAction = foreverAction
        
        return node
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
                
    }
    
    private func createPreloadedResources() {
    
    }
    
}
