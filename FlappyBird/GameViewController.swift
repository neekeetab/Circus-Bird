//
//  GameViewController.swift
//  FlappyBird
//
//  Created by Nikitab Belousov on 4/2/16.
//  Copyright (c) 2016 Nikitab Belousov. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = StartMenuScene(size:CGSize(width: 2048, height: 2732))
        scene.scaleMode = .AspectFill
//        (view as! SKView).showsFPS = true
        (view as! SKView).presentScene(scene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
