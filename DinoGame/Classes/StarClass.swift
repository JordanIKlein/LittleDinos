//
//  StarClass.swift
//  DinoGame
//
//  Created by Jordan Klein on 7/1/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit
import AVFoundation


class Star: SKSpriteNode,SKPhysicsContactDelegate {
    let imageTexture1 = SKTexture(imageNamed: "star")
    
    //scaling
    let scale1 = SKAction.scale(by: 0.20, duration: 0.02)
    let boomSound = SKAction.playSoundFileNamed("boom.wav", waitForCompletion: true)
    let explosionSound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    var health = 100
    init() {
        super.init(texture: nil, color: .clear, size: CGSize.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        isUserInteractionEnabled = true
        name = "star"
        self.zPosition = 50
        self.zPosition = 1
        self.texture = imageTexture1
        self.size = imageTexture1.size()
        setPhysics()
        
    }
    func setPhysics(){
        //let texture = SKTexture(imageNamed: "as")
        let animationDuration:TimeInterval = 3.0
        var actionArray = [SKAction]()
        actionArray.append(SKAction.moveBy(x: CGFloat(Int.random(in: -100...100)), y: CGFloat(Int.random(in: -100...100)), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        self.run(SKAction.sequence(actionArray))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        collectedStars = collectedStars + 1
        UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
        run(SKAction.sequence([scale1,SKAction.removeFromParent()]))
    }
    
}
