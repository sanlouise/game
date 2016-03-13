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
        // Create a ground property so that the bird does not fall off the screen.
        // Add the Node to the screen/scene.
        self.addChild(bird)
        
        


    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
