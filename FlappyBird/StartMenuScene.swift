//
//  StartMenuScene.swift
//  FlappyBird
//
//  Created by Nikitab Belousov on 4/12/16.
//  Copyright © 2016 Nikitab Belousov. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class StartMenuScene: WorldScene {
    
    override func didMoveToView(view: SKView) {
 
        super.didMoveToView(view)
        createButtons()
        
    }
    
    func createButtons() {
        let upperButton = AGSpriteButton(imageNamed: "buttonPlay")
        upperButton.position = CGPoint(x: size.width/2, y: size.height/3 + 160)
        upperButton.setTouchUpAction(SKAction.runBlock({
            
            let gameScene = GameScene(size:CGSize(width: 2048, height: 2732))
            gameScene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(0.5)
            
            self.view!.presentScene(gameScene, transition: transition)
        }))
        
        
        let lowerButton = AGSpriteButton(imageNamed: "buttonStats")
        lowerButton.position = CGPoint(x: size.width/2, y: size.height/3 - 150)
        lowerButton.setTouchUpAction(SKAction.runBlock({
            let statsScene = StatsScene(size:CGSize(width: 2048, height: 2732))
            statsScene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(0.5)
            
            self.view!.presentScene(statsScene, transition: transition)

        }))
        addChild(upperButton)
        addChild(lowerButton)
    }
}
