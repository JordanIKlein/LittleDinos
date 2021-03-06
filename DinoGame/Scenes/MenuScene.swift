//
//  MenuScene.swift
//  DinoGame
//
//  Created by Jordan Klein on 6/9/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVKit
import AVFoundation

// Background images
var backgroundFrames: [SKTexture] = []
var backgroundImage = SKSpriteNode()
// Custom Green Color for backgrounds
let customGreen = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
// Back button
let backButton = UIButton()

// Total number of stars collected to be used to by items.
var collectedStars = UserDefaults.standard.integer(forKey: "starcollection")


class MenuScene: SKScene{
    //Button
    let playButton = UIButton()
    let optionsButton = UIButton()
    let aboutButton = UIButton()
    let shopButton = UIButton()
    let highscoreButton = UIButton()
    
        
    //Text
    let aboutSection = SKLabelNode (fontNamed: "Press Start 2P")
    override func didMove(to view: SKView) {
        for view in view.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        }
        removeAllChildren()
        removeAllActions()
        background() //background
        buttons()//buttons, play, upgrades, options(sound), about
        text() // creates information for the about section
        mainTitle() //loads in main title
        
    }

    func background(){
        // Creating a black background
        let blackbackground = SKSpriteNode(imageNamed: "blackbackground")
        blackbackground.zPosition = -1000
        blackbackground.anchorPoint = CGPoint (x:0.0, y: 0.0)
        addChild(blackbackground)
        // Creating a texture for all of the frames
        var backgroundTextures:[SKTexture] = []
        for i in 1...14 {
              backgroundTextures.append(SKTexture(imageNamed: "Dino\(i)"))
        }
        let firstFrameTexture = backgroundTextures[0]
        backgroundImage = SKSpriteNode(texture: firstFrameTexture)
        backgroundImage.anchorPoint = CGPoint(x:0.0,y:0.0)
        backgroundImage.zPosition = 0
        addChild(backgroundImage)
        //Animating the background here
        backgroundImage.run(SKAction.repeatForever(SKAction.animate(with: backgroundTextures, timePerFrame: 0.25, resize: false, restore: true)))
        //Star Textures behind
        if let particles = SKEmitterNode(fileNamed: "Stars"){
            particles.position = CGPoint(x: -10, y: screenHeight)
            particles.zPosition = -1000
            particles.advanceSimulationTime(60)
            addChild(particles)
        }
    }
    func buttons(){
        // Play Button
        playButton.frame = CGRect (x:frame.midX - 175, y:frame.midY - 140, width: 350, height: 50)
        let title = NSLocalizedString("play", comment: "My comment")
        playButton.setTitle(title, for: UIControl.State.normal)
        playButton.setTitleColor(UIColor.white, for: .normal)
        playButton.backgroundColor = .clear
        playButton.layer.cornerRadius = 10
        playButton.layer.borderWidth = 2
        playButton.layer.borderColor=UIColor.white.cgColor
        playButton.addTarget(self, action: #selector(playGame), for: UIControl.Event.touchUpInside)
        playButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 20)
        playButton.titleLabel!.textAlignment = NSTextAlignment.center
        playButton.backgroundColor = customGreen
        self.view!.addSubview(playButton)
        // About Button
        aboutButton.frame = CGRect (x:frame.midX - 175 , y:frame.midY + 60, width: 350, height: 50)
        let aboutTitle = NSLocalizedString("about", comment: "My comment")
        aboutButton.setTitle(aboutTitle, for: UIControl.State.normal)
        aboutButton.setTitleColor(UIColor.white, for: .normal)
        aboutButton.backgroundColor = .clear
        aboutButton.layer.cornerRadius = 10
        aboutButton.layer.borderWidth = 2
        aboutButton.layer.borderColor=UIColor.white.cgColor
        aboutButton.addTarget(self, action: #selector(aboutGame), for: UIControl.Event.touchUpInside)
        aboutButton.backgroundColor = customGreen
        aboutButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 20)
        aboutButton.titleLabel!.textAlignment = NSTextAlignment.center
        self.view!.addSubview(aboutButton)
        // SHOP Button
        shopButton.frame = CGRect (x:frame.midX - 175, y:frame.midY - 40, width: 350, height: 50)
        let shopTitle = NSLocalizedString("shop", comment: "My comment")
        shopButton.setTitle(shopTitle, for: UIControl.State.normal)
        shopButton.setTitleColor(UIColor.white, for: .normal)
        shopButton.backgroundColor = .clear
        shopButton.layer.cornerRadius = 10
        shopButton.layer.borderWidth = 2
        shopButton.layer.borderColor=UIColor.white.cgColor
        shopButton.addTarget(self, action: #selector(shopScene), for: UIControl.Event.touchUpInside)
        shopButton.backgroundColor = customGreen
        shopButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 20)
        shopButton.titleLabel!.textAlignment = NSTextAlignment.center
        self.view!.addSubview(shopButton)
        // Highscore Area
        highscoreButton.frame = CGRect(x:frame.midX - 175, y: frame.midY + 160, width:  350, height:  50)
        let highscoreTitle = NSLocalizedString("highscore", comment: "My comment")
        highscoreButton.setTitle(highscoreTitle, for: UIControl.State.normal)
        highscoreButton.setTitleColor(UIColor.white, for: .normal)
        highscoreButton.backgroundColor = .clear
        highscoreButton.layer.cornerRadius = 10
        highscoreButton.layer.borderWidth = 2
        highscoreButton.layer.borderColor=UIColor.white.cgColor
        highscoreButton.addTarget(self, action: #selector(highscoreGame), for: UIControl.Event.touchUpInside)
        highscoreButton.backgroundColor = customGreen
        highscoreButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 20)
        highscoreButton.titleLabel!.textAlignment = NSTextAlignment.center
        self.view!.addSubview(highscoreButton)
        // Stars Amount
        starLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.2)
        starLabel.fontSize = 15
        starLabel.text = "\(starTitle):\(collectedStars)" // make a score that increases
        starLabel.name = "starLabel"
        starLabel.zPosition = 100
        addChild(starLabel)
        // Back button ... used in the options and about section
        backButton.frame = CGRect (x:frame.midX - 100 , y:frame.minY + 220, width: 200, height: 40)
        let backTitle = NSLocalizedString("back", comment: "My comment")
        backButton.setTitle(backTitle, for: UIControl.State.normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.backgroundColor = customGreen
        backButton.layer.cornerRadius = 10
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor=UIColor.white.cgColor
        backButton.addTarget(self, action: #selector(backbuttonRun), for: UIControl.Event.touchUpInside)
        backButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 20)
        backButton.titleLabel!.textAlignment = NSTextAlignment.center
        
    }
    @objc func playGame(sender: UIButton!) {
        starLabel.removeFromParent()
        let nextScene = GameScene(size: scene!.size)
        let transition = SKTransition.fade(withDuration: 0.0)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene,transition: transition)
    }
    @objc func highscoreGame(sender: UIButton!) {
        let nextScene = HighscoreScene(size: scene!.size)
        let transition = SKTransition.fade(withDuration: 0.0)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene,transition: transition)
    }
    @objc func aboutGame(sender: UIButton!) {
        
        for view in view!.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        }
        starLabel.removeFromParent()
        addChild(aboutSection)
        self.view!.addSubview(backButton)
    }
    
    @objc func shopScene(sender: UIButton!) {
        starLabel.removeFromParent()
        let nextScene = ShopScene(size: scene!.size)
        let transition = SKTransition.fade(withDuration: 0.0)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene,transition: transition)
    }
    @objc func backbuttonRun(sender: UIButton!) {
        for view in view!.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        }
        starLabel.removeFromParent()
        aboutSection.removeFromParent()
        buttons()
    }
    
    
    func text(){
        let textsection = NSLocalizedString("textsection", comment: "My comment")
        aboutSection.text =
        "\(textsection)"
        aboutSection.fontSize = 17
        aboutSection.fontColor = SKColor.black
        aboutSection.position = CGPoint (x:frame.midX, y:frame.midY/2)
        aboutSection.numberOfLines = -1
        aboutSection.horizontalAlignmentMode = .center
        aboutSection.verticalAlignmentMode = .center
        aboutSection.zPosition = 200
    }
    func mainTitle(){
        let mainText = SKLabelNode(fontNamed: "Connection III")
        mainText.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.8)
        let littleDinosection = NSLocalizedString("littledino", comment: "My comment")
        mainText.text = "\(littleDinosection)"
        mainText.fontSize = 20
        mainText.zPosition = 10000
        let arrayOfColors = [UIColor.systemTeal,UIColor.orange,UIColor.green,UIColor.systemPink,UIColor.red]
        let upScaling = SKAction.scale(by: 2.0, duration: 2.0)
        let downScaling = SKAction.scale(by: 0.5, duration: 2.0)
        let colorChange = SKAction.run {
            let fontColor = arrayOfColors.randomElement()
            mainText.fontColor = fontColor
        }
        //Change colors?
        let seq = SKAction.sequence([upScaling,colorChange,downScaling])
        mainText.run(SKAction.repeatForever(seq))
        addChild(mainText)
    }
}

