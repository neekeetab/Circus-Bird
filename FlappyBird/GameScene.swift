import UIKit
import SpriteKit

enum GameState {
    case ready
    case running
    case pause
    case over
}

class GameScene: WorldScene, SKPhysicsContactDelegate {
    
    // convert from screen coordinate system to scene coordinate system
    func convert(point: CGPoint) -> CGPoint {
        return self.view!.convertPoint(CGPoint(x: point.x, y:self.view!.frame.height-point.y), toScene:self)
    }
    
    var gameState = GameState.ready
    
    let gameSpeed = 400.0
    let gravity = 33.0
    let impulse: CGFloat = 1700.0
    let distanceToFirstCircle: CGFloat = 2200.0
    let distanceBetwewnCircles: CGFloat = 700.0
    let gapBetweenCircles: CGFloat = 400.0
    let numberOfCircles = 5
    var circles: [SKNode]!
    var score: SKLabelNode!
    
    var circlesMoveAction: [SKAction]!
    var preloadedActions: Dictionary<String, SKAction>!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        createPreloadedResources()
        
        createBird()
        createCircles()
        createInstructions()
        createPauseButton()
        
        createScore()
        showScore(0)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -gravity)
        physicsWorld.contactDelegate = self
        
//        addChild(pointSoundNode)
    
    }
    
    func createPauseButton() {
        
        let pauseButton = AGSpriteButton(imageNamed: "buttonPause")
        pauseButton.zPosition = 9000
        
        let screen = UIScreen.mainScreen().bounds
        pauseButton.position = convert(CGPoint(x: 40, y: screen.height - 40))
        
        pauseButton.setTouchUpAction(SKAction.runBlock({
            
            if self.gameState == .running {
                self.gameState = .pause
                let instructions = self.childNodeWithName("instructions")
                let fadeInAction = SKAction.fadeInWithDuration(0.35)
                instructions?.runAction(fadeInAction)
                
                if let bird = self.childNodeWithName("bird") {
                    bird.physicsBody?.dynamic = false
                    bird.physicsBody?.velocity = CGVectorMake(0, 0)
                }
                
                let amplitude: CGFloat = 40
                let cycleDuration: Double = 0.5
                let up = SKAction.moveByX(0, y: amplitude, duration: cycleDuration / 2)
                let down = SKAction.moveByX(0, y: -amplitude, duration: cycleDuration / 2)
                let sequence = SKAction.sequence([up, down])
                self.childNodeWithName("bird")?.runAction(SKAction.repeatActionForever(sequence), withKey: "upDownAction")
                
                for i in 0 ..< self.numberOfCircles {
                    self.circles[i].paused = true
                }
                
            }
        }))
        
        addChild(pauseButton)
        
    }
    
    func createScore() {
        
        score = SKLabelNode(fontNamed: "04B19")
        score.fontSize = 200
        score.position = CGPoint(x: size.width/2, y: size.height * 0.8 )
        score.zPosition = 8000
        addChild(score)
        
    }
    
    func showScore(number: UInt) {
        
        score.text = String(number)
        
    }
    
    func createPreloadedResources() {
        
        preloadedActions = Dictionary()
        //-----------------------------------------//
        let fadeDuration = 0.3
        let whiteScreen = SKSpriteNode(color: UIColor.whiteColor(), size: size)
        whiteScreen.anchorPoint = CGPointZero
        whiteScreen.zPosition = 1000
        whiteScreen.alpha = 0
        whiteScreen.name = "whiteScreen"
        addChild(whiteScreen)
        //-----------------------------------------//
        let splashAction = SKAction.sequence([SKAction.fadeAlphaTo(0.95, duration: fadeDuration * 1 / 6) , SKAction.fadeAlphaTo(0, duration: fadeDuration * 5 / 6), SKAction.removeFromParent()])
        let shakeAction = SKAction.sequence([SKAction.moveBy(CGVector(dx: 50, dy: 50), duration: 0.1), SKAction.moveBy(CGVector(dx: -50, dy: -50), duration: 0.1)])
        preloadedActions["splashAction"] = splashAction
        preloadedActions["shakeAction"] = shakeAction
        
    }
    
    func createInstructions() {
        
        let instructions = SKSpriteNode(imageNamed: "tapToPlay")
        instructions.position = CGPoint(x: size.width / 2, y: size.height / 2)
        instructions.zPosition = 10
        instructions.name = "instructions"
        addChild(instructions)
        
    }
    
    func runCircles() {
        
        for i in 0 ..< numberOfCircles {
            circles[i].runAction(circlesMoveAction[i])
        }
        
    }
    
    func createCircles() {
        
        circlesMoveAction = Array()
        circles = Array()
        
        for i in 0 ..< numberOfCircles {
            
            let circleFront = SKSpriteNode(imageNamed: "circleFront")
            let circleBack = SKSpriteNode(imageNamed: "circleBack")
            
            let circle = SKSpriteNode()
            circle.addChild(circleFront)
            circle.addChild(circleBack)
            circle.name = "circle"
            circle.position = CGPoint(x: distanceToFirstCircle + CGFloat(i) * distanceBetwewnCircles, y: size.height / 2)
            
            let positionVerticalyAction = SKAction.runBlock({
                circle.position = CGPoint(x: circle.position.x, y: CGFloat.random(min: self.size.height * 0.4, max: self.size.height * 0.85))
            })
            
            // simulating stack-like movement of circles
            
            let firstMoveBy = CGFloat(i + 1) * distanceBetwewnCircles + distanceToFirstCircle
            let firstMoveAction = SKAction.moveBy(CGVector(dx: -firstMoveBy, dy: 0), duration: Double(firstMoveBy) / gameSpeed)
            
            let moveBy = distanceBetwewnCircles * CGFloat(numberOfCircles)
            let resetAction = SKAction.moveBy(CGVector(dx: moveBy, dy: 0), duration: 0)
            
            let moveAction = SKAction.moveBy(CGVector(dx: -moveBy, dy: 0), duration: Double(moveBy) / gameSpeed)
            
            let foreverAction = SKAction.repeatActionForever(SKAction.sequence([positionVerticalyAction, resetAction,  moveAction]))
            
            // physics
            
            let circleCollisionMaskUpperTexture = SKTexture(imageNamed: "collisionMask1")
            let physicsBodyUpper = SKPhysicsBody(texture: circleCollisionMaskUpperTexture, size: circleCollisionMaskUpperTexture.size())
            
            let circleCollisionMaskLowerTexture = SKTexture(imageNamed: "collisionMask2")
            let physicsBodyLower = SKPhysicsBody(texture: circleCollisionMaskLowerTexture, size: circleCollisionMaskLowerTexture.size())
            
            circle.physicsBody = SKPhysicsBody(bodies: [physicsBodyLower, physicsBodyUpper])
            circle.physicsBody!.contactTestBitMask = circle.physicsBody!.collisionBitMask
            circle.physicsBody?.usesPreciseCollisionDetection = true
            circle.physicsBody!.dynamic = false
            
            //
            
            circleFront.zPosition = 21
            circleBack.zPosition = 19
            addChild(circle)
            
            circlesMoveAction.append(SKAction.sequence([positionVerticalyAction, firstMoveAction, foreverAction]))
            circles.append(circle)
        }
    }
    
    func createBird() {
        
        let bird = SKSpriteNode(imageNamed: "circusBird1")
        bird.name = "bird"
        let texture1 = SKTexture(imageNamed: "circusBird1")
        let texture2 = SKTexture(imageNamed: "circusBird2")
        let animation = SKAction.animateWithTextures([texture1, texture2], timePerFrame: 0.15)
        let animateAction = SKAction.repeatActionForever(animation)
        bird.runAction(animateAction)
        
        let amplitude: CGFloat = 40
        let cycleDuration: Double = 0.5
        let up = SKAction.moveByX(0, y: amplitude, duration: cycleDuration / 2)
        let down = SKAction.moveByX(0, y: -amplitude, duration: cycleDuration / 2)
        let sequence = SKAction.sequence([up, down])
        bird.runAction(SKAction.repeatActionForever(sequence), withKey: "upDownAction")
        
        // physics
        
        bird.physicsBody = SKPhysicsBody(texture: texture1, size: texture1.size())
        bird.physicsBody!.contactTestBitMask = bird.physicsBody!.collisionBitMask
        bird.physicsBody?.usesPreciseCollisionDetection = true
        bird.physicsBody!.dynamic = false
        
        //
        
        bird.zPosition = 20
        bird.position = convert(CGPoint(x: (view?.frame.width)! * 0.3, y: (view?.frame.height)! * 0.6))
        
        addChild(bird)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let _ = touches.first {
            
            if gameState == .ready {
                gameState = .running
                if let instructions = childNodeWithName("instructions") {
                    let fadeAction = SKAction.fadeOutWithDuration(0.35)
                    instructions.runAction(fadeAction)
                }
                runCircles()
                if let bird = childNodeWithName("bird") {
                    bird.removeActionForKey("upDownAction")
                    bird.physicsBody!.dynamic = true
                }
                
            } else if gameState == .running {
                
                if let bird = childNodeWithName("bird") {
                    bird.physicsBody?.velocity = CGVectorMake(0, 0)
                    bird.physicsBody?.applyImpulse(CGVectorMake(0, impulse))
                }
            } else if gameState == .pause {
                
                gameState = .running
                if let bird = childNodeWithName("bird") {
                    bird.physicsBody!.dynamic = true
                }
                
                for i in 0 ..< numberOfCircles {
                    circles[i].paused = false
                }
                
                if let instructions = childNodeWithName("instructions") {
                    let fadeAction = SKAction.fadeOutWithDuration(0.35)
                    instructions.runAction(fadeAction)
                }
                
                if let bird = childNodeWithName("bird") {
                    bird.removeActionForKey("upDownAction")
                    bird.physicsBody!.dynamic = true
                }
                
            }
            
        }
    }
    
    func splashAndShakeScreen() {
        
        childNodeWithName("whiteScreen")?.runAction(preloadedActions["splashAction"]!)
        runAction(preloadedActions["shakeAction"]!)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        physicsWorld.contactDelegate = nil
        
        runAction(SKAction.playSoundFileNamed("soundHit", waitForCompletion: false))
        
        // stop animations and allow bird to fall off screen when game is over
        
        for s in ["bird", "circle", "backgroundNear", "backgroundMedium", "backgroundFar"] {
            enumerateChildNodesWithName(s) { (sprite, nil) in
                sprite.removeAllActions()
                if sprite.name != "bird" {
                    sprite.physicsBody = nil
                }
            }
        }
        
        splashAndShakeScreen()
        gameState = .over
    
        // show new scene 
        
        let scene = GameOverScene(size: self.size)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            scene.scaleMode = .AspectFill
            self.view!.presentScene(scene)
            scene.showScore(self.scoreNumber)
        })
        
    }
    
    var scoreNumber:UInt = 0
    var lastTime: CFTimeInterval = 0
    var distance = 0.0
    override func update(currentTime: CFTimeInterval) {
        
        if gameState == .running {
        
            if lastTime == 0 {
                lastTime = currentTime
                return
            }
        
            let dx = (currentTime - lastTime) * gameSpeed
        
            distance += dx
            let scoreNumber = Int((CGFloat(distance) - distanceToFirstCircle) / distanceBetwewnCircles + 5) - 3 // Int
            
            if (scoreNumber > 0 && UInt(scoreNumber) != self.scoreNumber) {
                runAction(SKAction.playSoundFileNamed("soundPoint", waitForCompletion: false))
            }
            
            if scoreNumber > 0 {
                self.scoreNumber = UInt(scoreNumber)
                showScore(self.scoreNumber)
            }
            
            lastTime = currentTime
        }
        
    }
    
}



