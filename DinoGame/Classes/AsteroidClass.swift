//
//  AsteroidClass.swift
//  DinoGame
//
//  Created by Jordan Klein on 6/8/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit
import AVFoundation



class Enemy: SKSpriteNode,SKPhysicsContactDelegate {
    //Normal textures
    let imageTexture1 = SKTexture(imageNamed: "as")
    let imageTexture2 = SKTexture(imageNamed: "as2")
    let imageTexture3 = SKTexture(imageNamed: "as3")
    // Green
    let imageTexture4 = SKTexture(imageNamed: "asGreen")
    let imageTexture5 = SKTexture(imageNamed: "asGreen2")
    let imageTexture6 = SKTexture(imageNamed: "asGreen3")
    // Blue
    let imageTexture7 = SKTexture(imageNamed: "asBlue")
    let imageTexture8 = SKTexture(imageNamed: "asBlue2")
    let imageTexture9 = SKTexture(imageNamed: "asBlue3")
    // Red
    let imageTexture10 = SKTexture(imageNamed: "asRed")
    let imageTexture11 = SKTexture(imageNamed: "asRed2")
    let imageTexture12 = SKTexture(imageNamed: "asRed3")
    // Purple
    let imageTexture13 = SKTexture(imageNamed: "asPurple")
    let imageTexture14 = SKTexture(imageNamed: "asPurple2")
    let imageTexture15 = SKTexture(imageNamed: "asPurple3")
    //Mix
    let imageTexture16 = SKTexture(imageNamed: "asMix")
    let imageTexture17 = SKTexture(imageNamed: "asMix2")
    let imageTexture18 = SKTexture(imageNamed: "asMix3")
    //scaling
    let scale1 = SKAction.scale(by: 1.05, duration: 0.0)
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
        name = "asteroid"
        self.zPosition = 50
        self.health = 100
        self.zPosition = 2
        // Which asteroid did the user pick?
        if asteroid == "asteroid1"{
            self.texture = imageTexture1
        } else if asteroid == "asteroid2" {
            self.texture = imageTexture4
        } else if asteroid == "asteroid3" {
            self.texture = imageTexture7
        } else if asteroid == "asteroid4" {
            self.texture = imageTexture10
        } else if asteroid == "asteroid5" {
            self.texture = imageTexture13
        } else if asteroid == "asteroid6" {
            self.texture = imageTexture16
        }
        self.physicsBody?.restitution = 0.0
        self.size = imageTexture1.size()
        setPhysics()
        
    }
    func setPhysics(){
        //let texture = SKTexture(imageNamed: "as")
        self.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = CollisionType.asteroid.rawValue
        self.physicsBody?.contactTestBitMask = CollisionType.ground.rawValue
        self.physicsBody?.collisionBitMask = CollisionType.ground.rawValue
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        health = health - 25
        score = score + 15
        if health == 100 {
            if asteroid == "asteroid1"{
                self.texture = imageTexture1
            } else if asteroid == "asteroid2" {
                self.texture = imageTexture4
            } else if asteroid == "asteroid3" {
                self.texture = imageTexture7
            } else if asteroid == "asteroid4" {
                self.texture = imageTexture10
            } else if asteroid == "asteroid5" {
                self.texture = imageTexture13
            } else if asteroid == "asteroid6" {
                self.texture = imageTexture16
            }
            self.run(scale1)
        }
        if health == 75{
            if asteroid == "asteroid1"{
                self.texture = imageTexture2
            } else if asteroid == "asteroid2" {
                self.texture = imageTexture5
            } else if asteroid == "asteroid3" {
                self.texture = imageTexture8
            } else if asteroid == "asteroid4" {
                self.texture = imageTexture11
            } else if asteroid == "asteroid5" {
                self.texture = imageTexture14
            } else if asteroid == "asteroid6" {
                self.texture = imageTexture17
            }
            self.run(scale1)
            run(boomSound)
        }
        if health == 50{
            if asteroid == "asteroid1"{
                self.texture = imageTexture3
            } else if asteroid == "asteroid2" {
                self.texture = imageTexture6
            } else if asteroid == "asteroid3" {
                self.texture = imageTexture9
            } else if asteroid == "asteroid4" {
                self.texture = imageTexture12
            } else if asteroid == "asteroid5" {
                self.texture = imageTexture15
            } else if asteroid == "asteroid6" {
                self.texture = imageTexture18
            }
            self.run(scale1)
            run(boomSound)
        }
        if health == 25{
            run(explosionSound)
            self.physicsBody = nil
            run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.run{self.removeFromParent()}]))
            score = score + 35
        }
        
    }
    
}
//Old way of running sound before weird error
//run(SKAction.playSoundFileNamed("boom.wav", waitForCompletion: true))

