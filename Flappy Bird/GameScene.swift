//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Sandra Adams-Hallie on Mar/12/16.
//  Copyright (c) 2016 Sandra Adams-Hallie. All rights reserved.
//

import SpriteKit

// To detect collision, add SKPhysicsContactDelegate.
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Add Nodes for each object that will be displayed.
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var labelContainer = SKSpriteNode()
    var movingObjects = SKSpriteNode()
    
    var gameOver = false
    var score = 0
    
    // Use enum to define categories. To make a new case, naming them is exponential. Next one would be 4, 3 is a combination of Bird and Object.
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    func makeBackground() {
        //  Make sure to first set the code for the background so that the animation will not be overrun and thus invisible.
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        // Make the background move to the left to create the illusion that the bird is moving right.
        let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 9)
        // To make sure the background 'does not run out', it should repeat after the view is finished.
        // Jumps the background back to its original position. Duration 0 to move immediately.
        let replaceBackground = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
        let moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, replaceBackground]))


        // To get rid of the greyness after the background has finished.
        for var i: CGFloat = 0; i<3; i++ {
        // Add texture to background.
        background = SKSpriteNode(texture: backgroundTexture)
        //Position and size background. Because there are 3 i instances, there won't be a grey gap in between.
        background.position = CGPoint(x: backgroundTexture.size().width/2 + backgroundTexture.size().width * i, y: CGRectGetMidY(self.frame))
        background.size.height = self.frame.height
        background.zPosition = -1

        // Apply to the background
        background.runAction(moveBackgroundForever)
        movingObjects.addChild(background)
        }
    }
    
    //Equivalent viewDidLoad
    override func didMoveToView(view: SKView) {
        
        // Set delegate of SKPhysicsContactDelegate here.
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makeBackground()
        
        // Set properties for the scorelabel.
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        // Set the properties for the animated bird.
        // When using spriteKit, define objects that will be animated as a Texture.
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        //Create animation
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        // Repeat animation
        let birdFlapForever = SKAction.repeatActionForever(animation)
        // Apply the texture to the bird
        bird = SKSpriteNode(texture: birdTexture)
        //Tell XCode where to put the animated bird (middle).
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.zPosition = 1
        // Add animation to bird Sprite
        bird.runAction(birdFlapForever)
        // Arrange the gravity/ collisions with other objects. Half the height of the bird image should be affected.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        // Apply gravity.
        bird.physicsBody!.dynamic = true
        bird.physicsBody!.allowsRotation = false
        // Take care of collisions.
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
//      This line is not relevant to us, sets whether objects can pass through one another.
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        // Add the Node to the screen/scene.
        self.addChild(bird)
        
        
        // Create an invisible (thus not a sprite) ground property so that the bird does not fall off the screen.
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.zPosition = 2
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        //Ground should not be affected by gravity.
        ground.physicsBody!.dynamic = false
        
        // Take care of collisions.
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        // Because this line is the same as in bird, a collision is now detectable.
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        // This line is not relevant to us, sets whether objects can pass through one another.
        //ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        //Add ground to the scene.
        self.addChild(ground)

        // Pipes should appear on a regular time basis. Change this to change the level of the game.
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("createPipes"), userInfo: nil, repeats: true)
    }
    
    func createPipes() {
        
        // Add a gap for in between the pipes.
        let gapHeight = bird.size.height * 4
        //Create randomness for positions pipes. Move at max half of the screen. COnvert to UInt32.
        let moveAmount = arc4random() % UInt32(self.frame.size.height / 2)
        // Limit the movement between top and bottom quarter of screen.
        let pipeOffset = CGFloat(moveAmount) - self.frame.size.height / 4
        
        // Create animation to move the pipes.
        // The pipes start off at the very right and will move off the screen to the left. They are moved twize the width of the screen to the left. Constant speed regardless of the screen width.
        let movePipes = SKAction.moveByX(-self.frame.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        // Let pipes disappear.
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        // Set the properties for pipe 1.
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        // Set position for the pipe. Add a 1000 pixels from the bottom.
        // The following line sets the pipe to reach exactly the middle. For pipe 2, subtract instead of add. pipe1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + pipeTexture.size().height/2). To make the pipes reappear on the right, add self.frame.size.width.
        pipe1.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) + pipeTexture.size().height/2 + gapHeight/2 + pipeOffset)
        // Add animation to the pipe.
        pipe1.runAction(moveAndRemovePipes)
        
        // Enable collisions.
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        // Remove gravity to pipes so they don't shoot off the screen.
        pipe1.physicsBody!.dynamic = false
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        // Because this line is the same as in bird, a collision is now detectable.
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        // Add the pipe to the scene.
        movingObjects.addChild(pipe1)
        
        // Set the properties for pipe 2.
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight/2 + pipeOffset)
        pipe2.runAction(moveAndRemovePipes)
        // Enable collisions.
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture.size())
        pipe2.physicsBody!.dynamic = false
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        movingObjects.addChild(pipe2)
        
        
        // Detecting the bird flying through the gap to increase the score.
        let gap = SKNode()
        // Middle of the pipes.
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width + pipe1.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, gapHeight))
        gap.physicsBody!.dynamic = false
        // Make 'Gap' its own BitMask so it can detect collision with the bird.
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        // Allow the bird to pass through.
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        movingObjects.addChild(gap)
    }
    
    // Detect a collision.
    func didBeginContact(contact: SKPhysicsContact) {
        // If the bird comes in contact with the gap, score is increased, game does not stop.
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            score++
            scoreLabel.text = String(score)
        } else {
            //Check if game is over or not, because this code should only execute once.
            if gameOver == false {
                gameOver = true
                // Stops all objects from moving.
                self.speed = 0
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelContainer.addChild(gameOverLabel)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Interaction is only allowed when the game is still running.
        if gameOver == false {
            // On each touch, an impulse should be applied so that the bird moves up.
            // 0 here - instantaneously set the velocity to 0
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            // Apply the impulse (jumping upwards), nothing horizontal, 50 vertically. Set the difficulty of the game here.
            bird.physicsBody!.applyImpulse(CGVectorMake(0, 50))
        } else {
            // Tap to play again.
            score = 0
            scoreLabel.text = "0"
            bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            movingObjects.removeAllChildren()
            labelContainer.removeAllChildren()
            makeBackground()
            self.speed = 1
            gameOver = false

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
