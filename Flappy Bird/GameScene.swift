//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Sandra Adams-Hallie on Mar/12/16.
//  Copyright (c) 2016 Sandra Adams-Hallie. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Add Nodes for each object that will be displayed.
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    

    //Equivalent viewDidLoad
    override func didMoveToView(view: SKView) {
        
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
            self.addChild(background)
        }
        
        
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
        // Add the Node to the screen/scene.
        self.addChild(bird)
        
        
        // Create an invisible (thus not a sprite) ground property so that the bird does not fall off the screen.
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        //Ground should not be affected by gravity.
        ground.physicsBody!.dynamic = false
        //Add ground to the scene.
        self.addChild(ground)
        
        
        // Add a gap for in between the pipes.
        let gapHeight = birdTexture.size().height * 4
        //Create randomness for positions pipes. Move at max half of the screen. COnvert to UInt32.
        let moveAmount = arc4random() % UInt32(self.frame.size.height / 2)
        // Limit the movement between top and bottom quarter of screen.
        let pipeOffset = CGFloat(moveAmount) - self.frame.size.height / 4
        
        
        // Set the properties for pipe 1.
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        // Set position for the pipe. Add a 1000 pixels from the bottom.
        // The following line sets the pipe to reach exactly the middle. For pipe 2, subtract instead of add. pipe1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + pipeTexture.size().height/2)
        pipe1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + pipeTexture.size().height/2 + gapHeight/2 + pipeOffset)
        //Add it to the scene.
        self.addChild(pipe1)
        
        
        // Set the properties for pipe 2.
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - pipe2Texture.size().height/2 - gapHeight/2 + pipeOffset)
        self.addChild(pipe2)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // On each touch, an impulse should be applied so that the bird moves up.
        // 0 here - instantaneously set the velocity to 0
        bird.physicsBody!.velocity = CGVectorMake(0, 0)
        // Apply the impulse (jumping upwards), nothing horizontal, 50 vertically. Set the difficulty of the game here.
        bird.physicsBody!.applyImpulse(CGVectorMake(0, 50))
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
