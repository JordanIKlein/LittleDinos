//
//  GameScene.swift
//  DinoGame
//
//  Created by Jordan Klein on 6/7/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//
// Replay Icon and Home Icon made by Freepik perfect from www.flaticon.com



import SpriteKit
import GameplayKit
import GoogleMobileAds
import GameKit


enum CollisionType: UInt32 {
    case asteroid = 1
    case ground = 2
    case star = 4
}
// Adcounter ... to reduce the number of ads displayed in the app
var adCount = UserDefaults.standard.integer(forKey: "AD Counter")
let starTitle = NSLocalizedString("starAmount", comment: "My comment")
// Screen Boundaries
let screenRect = UIScreen.main.bounds
let screenWidth = screenRect.size.width
let screenHeight = screenRect.size.height
// Score initialization
var score = Int()
var scoreLabel = SKLabelNode(fontNamed: "Press Start 2P")
//Star initialization
var starLabel = SKLabelNode(fontNamed: "Press Start 2P")
// Special Buttons
let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
let replayButton = SKSpriteNode(imageNamed: "replayButton")
let homeButton = SKSpriteNode(imageNamed: "homeButton")
//Timer for spawning asteroids
var officialTimer = Timer()
//High Score Control
var highscoreArray = UserDefaults.standard.integer(forKey: "highscore")
var waveArray = UserDefaults.standard.integer(forKey: "wave")
// creating a double to facilitate a wave change
var gravitydouble = double_t() //gravity double
var waveSKLabel = SKLabelNode(fontNamed: "Press Start 2P") //label displaying current wave
var numWave = Int() //counts the current wave
let blackbackground = SKSpriteNode(imageNamed: "blackbackground")

// Variable which allows for a continue button
var continueInt = UserDefaults.standard.integer(forKey: "continue") ?? 0
//Main Scene Control
class GameScene: SKScene, SKPhysicsContactDelegate {
    // Asking for a reivew
    let reviewService = ReviewService.shared
    // Physics relations
    override func didMove(to view: SKView) {
        
        // Removing UIButtons from the Menu
        for view in view.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        }
        if continueInt == 0 {
            score = 0 // Reseting the score back down to zero for each game
            background() // Adding the Background
            buttons() //Adding Pause Button, Labels, etc
            //Updating Game Timer
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.constantUpdate()
            }, SKAction.wait(forDuration: 0.01)])))
            startGame()
        } else {
            print("Continue Number: \(continueInt)")
            background() // Adding the Background
            buttons() //Adding Pause Button, Labels, etc
            //Updating Game Timer
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.constantUpdate()
            }, SKAction.wait(forDuration: 0.01)])))
            startGame()
            print("Reset")
        }
            
        
    }
    func buttons(){
        // Pause Button
        pauseButton.position = CGPoint(x: screenWidth * 0.85, y: screenHeight * 0.9)
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.name = "pause"
        pauseButton.zPosition = 1001
        pauseButton.physicsBody?.isDynamic = false
        addChild(pauseButton)
        //Score Label
        scoreLabel.position = CGPoint(x: screenWidth * 0.15, y: screenHeight * 0.9)
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 20
        scoreLabel.name = "scoreLabel"
        scoreLabel.zPosition = 0
        scoreLabel.physicsBody?.isDynamic = false
        addChild(scoreLabel)
        // Star Label
        starLabel.position = CGPoint(x: screenWidth * 0.20, y: screenHeight * 0.85)
        starLabel.text = "\(starTitle):\(collectedStars)"
        starLabel.fontSize = 15
        starLabel.name = "starLabel"
        starLabel.zPosition = 0
        starLabel.physicsBody?.isDynamic = false
        addChild(starLabel)
    }
    func constantUpdate() {
        scoreLabel.text = "\(score)" // checks what the current score is
        starLabel.text = "\(starTitle): \(collectedStars)"
    }
    func startGame(){
        physics()
        limits()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.waves()
            }, SKAction.wait(forDuration: 15.0)])), withKey: "start")
    }
    func waves(){
        removeAction(forKey: "help")
        //Every time the wave is run, it is counted as a new wave.
        numWave = numWave + 1
        waveSKLabel.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        waveSKLabel.fontColor = UIColor.yellow
        let waveLevel = NSLocalizedString("level", comment: "My comment")
        waveSKLabel.text = "\(waveLevel) \(numWave)"
        waveSKLabel.zPosition = 1001
        waveSKLabel.physicsBody?.isDynamic = false
        waveSKLabel.removeFromParent()
        addChild(waveSKLabel)
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        let sequence = SKAction.sequence([fadeIn,fadeOut])
        waveSKLabel.run(sequence)
        //Here it runs the sequence of going in and out.
        if numWave <= 5 {
            gravitydouble = gravitydouble - 0.05
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnEnemy()
                }, SKAction.wait(forDuration: 1.5)])), withKey: "help")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnStar()
            }, SKAction.wait(forDuration: 8.0)])), withKey: "star")
        } else if numWave <= 10 && numWave > 5 {
            gravitydouble = gravitydouble - 0.1
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnEnemy()
                }, SKAction.wait(forDuration: 1.0)])), withKey: "help")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnStar()
            }, SKAction.wait(forDuration: 10.0)])), withKey: "star")
        } else {
            gravitydouble = gravitydouble - 0.20
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnEnemy()
                }, SKAction.wait(forDuration: 0.75)])), withKey: "help")
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.spawnStar()
            }, SKAction.wait(forDuration: 15.0)])), withKey: "star")
        }
        //Increasing the gravity so the asteroids fall faster.
        physicsWorld.gravity = CGVector(dx: 0.0,dy: gravitydouble)
        // ADD SKWAIT, try to get these two to wait a few minutes!
        
    }
    
    func physics(){
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0.9999
        numWave = 0
        gravitydouble = -0.20
    }
    func limits(){
    //Floor
    var groundPoints = [CGPoint(x: frame.minX - 1, y: frame.minY + 70),
                            CGPoint(x: frame.maxX + 1, y: frame.minY + 70)]
    let ground = SKShapeNode(splinePoints: &groundPoints,
                                 count: groundPoints.count)
    ground.lineWidth = 0
    ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
    ground.physicsBody?.restitution = 0
    ground.physicsBody?.friction = 0
    ground.physicsBody?.isDynamic = false
    ground.physicsBody?.categoryBitMask = CollisionType.ground.rawValue
    ground.physicsBody?.collisionBitMask = CollisionType.asteroid.rawValue
    ground.physicsBody?.contactTestBitMask = CollisionType.asteroid.rawValue
    addChild(ground)
    }
    func pauseGame(){
        // stops the world timer when the user pauses the game
        if let action = self.action(forKey: "start") {
            action.speed = 0
        }
        if let action = self.action(forKey: "help") {
            action.speed = 0
        }
        if let action = self.action(forKey: "star") {
            action.speed = 0
        }
        physicsWorld.speed = 0
        // creating a blur effect over the game
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view!.addSubview(blurEffectView)
        let playUIButton = UIButton()
        playUIButton.backgroundColor = customGreen
        playUIButton.frame = CGRect( x:frame.midX - 100, y:frame.midY - 50, width: 200, height: 75)
        let playTitle = NSLocalizedString("playGame", comment: "My comment")
        playUIButton.setTitle("\(playTitle)!", for: UIControl.State.normal)
        playUIButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 20)
        playUIButton.addTarget(self, action: #selector(playFunction), for: UIControl.Event.touchUpInside)
        playUIButton.setTitleColor(UIColor.white, for: .normal)
        playUIButton.layer.cornerRadius = 10
        playUIButton.layer.borderWidth = 2
        playUIButton.layer.borderColor=UIColor.white.cgColor
        view!.addSubview(playUIButton)
    }
    @objc func playFunction(sender: UIButton!) {
        //remove subviews
        for view in view!.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        if let action = self.action(forKey: "start") {
            action.speed = 1
        }
        if let action = self.action(forKey: "help") {
                action.speed = 1
        }
        if let action = self.action(forKey: "star") {
                action.speed = 1
        }
        pauseButton.removeFromParent()
        physicsWorld.speed = 0.9999
        addChild(pauseButton)
        }
    }
    
    func gameOver(){
        // ONLY SHOWING THE AD once every three games to give the player more game time and less ad experience
        adCount = adCount + 1
        UserDefaults.standard.set(adCount, forKey: "AD Counter")
        if adCount == 2{
            adCount = 0
            UserDefaults.standard.set(adCount, forKey: "AD Counter")
            NotificationCenter.default.post(name: .showInterstitialAd, object: nil)
        }
        //Remove everything from the world
        removeAllChildren()
        removeAllActions()
        //Add a backdrop background and a replay button
        blackbackground.zPosition = -1000
        addChild(blackbackground)
        //Star Textures behind
            if let particles = SKEmitterNode(fileNamed: "Stars"){
                particles.position = CGPoint(x: -10, y: screenHeight)
                particles.zPosition = 0
                particles.advanceSimulationTime(60)
                addChild(particles)
            }
        //Add buttons
        homeButton.name = "home"
        homeButton.position = CGPoint(x:frame.midX - 75,y: frame.midY - 80)
        homeButton.size = CGSize(width: 75, height: 75)
        homeButton.zPosition = 100
        addChild(homeButton)
        replayButton.name = "replay"
        replayButton.position = CGPoint(x:frame.midX + 75,y: frame.midY - 80)
        replayButton.zPosition = 100
        replayButton.size = CGSize(width: 75, height: 75)
        addChild(replayButton)
        // Adding Continue Button to Continue the game if pressed
        let continueButton = UIButton()
        continueButton.frame = CGRect (x:frame.midX - 175, y:screenHeight * 0.8, width: 350, height: 50)
        let title = NSLocalizedString("continue", comment: "My comment")
        // Continue for 50 stars
        continueButton.setTitle(title, for: UIControl.State.normal)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.backgroundColor = .clear
        continueButton.layer.cornerRadius = 10
        continueButton.layer.borderWidth = 2
        if collectedStars >= 50 {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
        continueButton.layer.borderColor=UIColor.white.cgColor
        continueButton.addTarget(self, action: #selector(continueGame), for: UIControl.Event.touchUpInside)
        continueButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 12)
        continueButton.titleLabel!.textAlignment = NSTextAlignment.center
        continueButton.backgroundColor = customGreen
        print("Continue Number Reading: \(continueInt)")
        if continueInt == 0 {
            continueInt = continueInt + 1
            UserDefaults.standard.setValue(continueInt, forKey: "continue")
            print("Continue Number should be 1: \(continueInt)")
            self.view!.addSubview(continueButton)
        } else if continueInt >= 1{
            for view in view!.subviews {
                if view is UIButton{
                    view.removeFromSuperview()
                } else {
                    view.removeFromSuperview()
                }
            }
            continueInt = 0
            UserDefaults.standard.setValue(continueInt, forKey: "continue")
            print("Continue Number should be greater than 0: \(continueInt)")
        }
        //Add SKLabel here to present one of a few phrases
        let goodTryLabel = SKLabelNode(fontNamed: "Press Start 2P")
        goodTryLabel.position = CGPoint(x:frame.midX, y: frame.midY + 150)
        let greatjob = NSLocalizedString("greatjob", comment: "My comment")
        let goodjob = NSLocalizedString("goodjob", comment: "My comment")
        let greattry = NSLocalizedString("greattry", comment: "My comment")
        let goodeffort = NSLocalizedString("goodeffort", comment: "My comment")
        let greateffort = NSLocalizedString("greateffort", comment: "My comment")
        let randomText = ["\(greatjob)!", "\(goodjob)!", "\(greattry)!", "\(goodeffort)!", "\(greateffort)!"]
        goodTryLabel.text = "\(randomText.randomElement() ?? "\(goodjob)!")"
        goodTryLabel.fontSize = 20
        goodTryLabel.zPosition = 100
        addChild(goodTryLabel)
        //Display cute dino and score
        let dinoSprite = SKSpriteNode(imageNamed: "dino")
        dinoSprite.position = CGPoint(x:frame.midX,y:frame.midY + 75)
        dinoSprite.size = CGSize(width:200,height:200)
        dinoSprite.zPosition = 3
        addChild(dinoSprite)
        //Add score
        scoreLabel.position = CGPoint(x:frame.midX, y: frame.midY)
        let scoretext = NSLocalizedString("score", comment: "My comment")
        scoreLabel.text = "\(scoretext):\(score)"
        addChild(scoreLabel)
        // Add stars label
        starLabel.position = CGPoint(x: scoreLabel.position.x, y: scoreLabel.position.y - 30)
        starLabel.text = "\(starTitle):\(collectedStars)"
        starLabel.fontSize = 20
        starLabel.name = "starLabel"
        starLabel.zPosition = 0
        starLabel.physicsBody?.isDynamic = false
        addChild(starLabel)
        if score > highscoreArray {
            highscoreArray = score
            UserDefaults.standard.setValue(score, forKey: "highscore")
            let newHighscore = GKScore(leaderboardIdentifier:"highscoredinos")
            newHighscore.value = Int64(highscoreArray)
            GKScore.report([newHighscore]) { error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                print("Added Highscore")
            }

        }
        //Checking for Highest level
        if numWave > waveArray {
            waveArray = numWave
            UserDefaults.standard.setValue(numWave, forKey: "wave")
            let newWave = GKScore(leaderboardIdentifier:"wavedinos")
            newWave.value = Int64(waveArray)
            GKScore.report([newWave]) { error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                print("Added Wave")
            }
        }
    }
    @objc func continueGame() {
        blackbackground.removeFromParent()
        scoreLabel.removeFromParent()
        starLabel.removeFromParent()
        
        collectedStars = collectedStars - 50
        UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
        let theScene = GameScene(size: scene!.size)
        let thetransition = SKTransition.fade(withDuration: 0.25)
        theScene.scaleMode = .aspectFill
        scene?.view?.presentScene(theScene,transition: thetransition)
    }
    
    
    func spawnStar(){
        let star = Star()
        let xPosition = CGFloat(frame.minX + star.size.height)
        let getYvalue = GKRandomDistribution(lowestValue: Int(frame.minY + star.size.width*3), highestValue: Int(frame.maxY - star.size.width/2))
        let nextYPosition = CGFloat(getYvalue.nextInt())
        star.position = CGPoint(x: xPosition, y: nextYPosition)
        addChild(star)
    }
    
    func spawnEnemy(){
        let enemy = Enemy()
        let yPosition = CGFloat(frame.maxY + enemy.size.height*2)
        let getXvalue = GKRandomDistribution(lowestValue: Int(frame.minX + enemy.size.width/2), highestValue: Int(frame.maxX - enemy.size.width/2))
        let xPosition = CGFloat(getXvalue.nextInt())
        enemy.position = CGPoint(x: xPosition, y: yPosition)
        addChild(enemy)
    }
    func background(){
        //Creating a black background
        blackbackground.zPosition = -1000
        blackbackground.anchorPoint = CGPoint (x:0.0, y: 0.0)
        addChild(blackbackground)
        // Creating a texture for all of the frames
        var backgroundTextures:[SKTexture] = []
        for i in 0...14 {
              backgroundTextures.append(SKTexture(imageNamed: "Dino\(i)"))
        }
        let firstFrameTexture = backgroundTextures[0]
        backgroundImage = SKSpriteNode(texture: firstFrameTexture)
        backgroundImage.physicsBody?.isDynamic = false
        backgroundImage.anchorPoint = CGPoint(x:0.0,y:0.0)
        backgroundImage.zPosition = 0
        addChild(backgroundImage)
        backgroundImage.run(SKAction.repeatForever(SKAction.animate(with: backgroundTextures, timePerFrame: 0.25, resize: false, restore: true)))
        //Star Textures behind
        if let particles = SKEmitterNode(fileNamed: "Stars"){
            particles.position = CGPoint(x: -10, y: screenHeight)
            particles.zPosition = -1000
            particles.advanceSimulationTime(60)
            addChild(particles)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in:self) {
            let nodesArray = self.nodes(at:location)
            if nodesArray.first?.name == "pause" {
                pauseButton.removeFromParent()
                pauseGame()
            }
            if nodesArray.first?.name == "replay" {
                removeAllChildren()
                removeAllActions()
                continueInt = 0
                UserDefaults.standard.setValue(continueInt, forKey: "continue")
                let theScene = GameScene(size: scene!.size)
                let thetransition = SKTransition.fade(withDuration: 0.15)
                theScene.scaleMode = .aspectFill
                scene?.view?.presentScene(theScene,transition: thetransition)
            }
            if nodesArray.first?.name == "home" {
                removeAllChildren()
                removeAllActions()
                // ask for review after game completed, waiting 2 seconds
                continueInt = 0
                UserDefaults.standard.setValue(continueInt, forKey: "continue")
                let deadline = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: deadline) {[weak self] in self?.reviewService.requestReview()
                }
                let theScene = MenuScene(size: scene!.size)
                let thetransition = SKTransition.fade(withDuration: 0.15)
                theScene.scaleMode = .aspectFill
                scene?.view?.presentScene(theScene,transition: thetransition)
            }
            
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
    let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == CollisionType.ground.rawValue | CollisionType.asteroid.rawValue {
            gameOver()
        }
    }
}
