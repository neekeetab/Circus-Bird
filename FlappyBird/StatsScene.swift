//
//  StatsScene.swift
//  FlappyBird
//
//  Created by Nikita Belousov on 6/8/16.
//  Copyright © 2016 Nikitab Belousov. All rights reserved.
//

import UIKit

class StatsScene: WorldScene {

    var scorePlate: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        createScorePlate()
        createBackButton()
        
    }
    
    func createScorePlate() {
        
        scorePlate = SKSpriteNode(imageNamed: "score")
        scorePlate.position = CGPoint(x: size.width/2, y: size.height / 2 - 100)
        addChild(scorePlate)
    
    }
    
    func createBackButton() {
        
        let button = AGSpriteButton(imageNamed: "menu")

        button.position = CGPoint(x: size.width/2, y: size.height/6)
        button.setTouchUpAction(SKAction.runBlock({
            
            let startScene = StartMenuScene(size:CGSize(width: 2048, height: 2732))
            startScene.scaleMode = .AspectFill
            let transition = SKTransition.crossFadeWithDuration(0.5)
            
            self.view!.presentScene(startScene, transition: transition)
        }))
        addChild(button)
        
    }
    
}
