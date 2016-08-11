//
//  GameOverScene.swift
//  FlappyBird
//
//  Created by Nikita Belousov on 6/5/16.
//  Copyright © 2016 Nikitab Belousov. All rights reserved.
//

import UIKit


class GameOverScene: WorldScene {

    var scorePlate: SKSpriteNode!
    
    var gameScene: GameScene!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        createScorePlate()
        createButtons()
        showPlace(3)
//        showScore(155)
        showBest(38)
        
        gameScene = GameScene(size:CGSize(width: 2048, height: 2732))
        
    }
    
    func showScore(score: UInt) {
        let label = SKLabelNode(fontNamed: "04B19")
        label.text = String(score)
        label.fontSize = 200
        label.position = CGPoint(x: 0, y: 755)
        scorePlate.addChild(label)
    }
    
    func showBest(score: UInt) {
        let label = SKLabelNode(fontNamed: "04B19")
        label.text = String(score)
        label.fontSize = 100
        label.position = CGPoint(x: 115, y: 600)
        scorePlate.addChild(label)
    }
    
    func showPlace(number: UInt) {
        if number < 4 {
            let place = SKSpriteNode(imageNamed: "scorePlateCup\(number)")
            scorePlate.addChild(place)
        }
    }
    
    func createScorePlate() {
        
        let scorePlateGlowOn = SKTexture(imageNamed: "scorePlateGlowOn")
        let scorePlateGlowOff = SKTexture(imageNamed: "scorePlateGlowOff")
        scorePlate = SKSpriteNode(texture: scorePlateGlowOff)
        
        let glowOffAction = SKAction.setTexture(scorePlateGlowOff)
        let glowOnAction = SKAction.setTexture(scorePlateGlowOn)
        let animation = SKAction.sequence([glowOnAction, SKAction.waitForDuration(0.3), glowOffAction, SKAction.waitForDuration(0.3)])
        scorePlate.runAction(SKAction.repeatActionForever(animation))
        scorePlate.position = CGPoint(x: size.width/2, y: size.height / 2 - 100)
        addChild(scorePlate)
    }
    
    func createButtons() {
        let upperButton = AGSpriteButton(imageNamed: "buttonReplay")
        upperButton.position = CGPoint(x: size.width/2, y: size.height/5.6 + 160)
        upperButton.setTouchUpAction(SKAction.runBlock({
            
            self.gameScene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(0.5)
            
            self.view!.presentScene(self.gameScene, transition: transition)
        }))
        
        
        let lowerButton = AGSpriteButton(imageNamed: "buttonStats")
        lowerButton.position = CGPoint(x: size.width/2, y: size.height/5.6 - 150)
        lowerButton.setTouchUpAction(SKAction.runBlock({
            
            let statsScene = StatsScene(size:CGSize(width: 2048, height: 2732))
            statsScene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(0.5)
            
            self.view!.presentScene(statsScene, transition: transition)
            
        }))
        addChild(upperButton)
        addChild(lowerButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        
    }
    
}
