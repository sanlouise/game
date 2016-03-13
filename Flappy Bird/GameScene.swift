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
        
//       Make sure to first set the code for the background so that the animation will not be overrun and thus invisible.
        
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        // Add texture to background.
        background = SKSpriteNode(texture: backgroundTexture)
        //Position and size background
        background.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        background.size.height = self.frame.height
        background.zPosition = -1
        
        // Make the background move to the left (by ten degrees) to create the illusion that the bird is moving right.
        let moveBackground = SKAction.moveByX(-10, y: 0, duration: 0.2)
        let moveBackgroundForever = SKAction.repeatActionForever(moveBackground)
        // Apply to the background
        background.runAction(moveBackgroundForever)
        
        self.addChild(background)
        
        
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
        // Add the Node to the screen/scene.
        self.addChild(bird)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
