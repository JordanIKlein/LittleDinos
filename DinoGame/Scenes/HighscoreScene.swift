//
//  HighscoreScene.swift
//  DinoGame
//
//  Created by Jordan Klein on 7/19/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SpriteKit


// Creating global UILabels for easier referencing
let UILabel1 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel2 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel3 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel4 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel5 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel6 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel7 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel8 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel9 = SKLabelNode(fontNamed: "Press Start 2P")
let UILabel10 = SKLabelNode(fontNamed: "Press Start 2P")

class HighscoreScene: SKScene {
    // Creasting personal labels here
    let highScoreLabel = SKLabelNode(fontNamed: "Press Start 2P")
    let waveLabel = SKLabelNode(fontNamed: "Press Start 2P")
    let personalLabel = SKLabelNode(fontNamed: "Press Start 2P")
    let top10Label = SKLabelNode(fontNamed: "Press Start 2P")
    
    private let database = Database.database().reference()
    
    
    override func didMove(to view: SKView) {
        //asks user to make up a username
        for view in view.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        }
        self.backgroundColor = .black
        backbutton()
        background()
        personalScore()
        setupLabels()
        database.child("Highscore").observe(<#T##eventType: DataEventType##DataEventType#>, with: <#T##(DataSnapshot) -> Void#>)
        database.child("Highscore").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                return
            }
            print("Value:\(value)")
        })
    }
    func background(){
            //Star Textures behind
            if let particles = SKEmitterNode(fileNamed: "Stars"){
                particles.position = CGPoint(x: -10, y: screenHeight)
                particles.zPosition = -1000
                particles.advanceSimulationTime(60)
                addChild(particles)
            }
    }
    func backbutton(){
        backButton.frame = CGRect (x:screenWidth * 0.5 - 100, y:screenHeight * 0.05, width: 200, height: 40)
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
        self.view!.addSubview(backButton)
    }
    @objc func backbuttonRun(sender: UIButton!) {
        UILabel1.removeFromParent()
        UILabel2.removeFromParent()
        UILabel3.removeFromParent()
        UILabel4.removeFromParent()
        UILabel5.removeFromParent()
        UILabel6.removeFromParent()
        UILabel7.removeFromParent()
        UILabel8.removeFromParent()
        UILabel9.removeFromParent()
        UILabel10.removeFromParent()
        highScoreLabel.removeFromParent()
        waveLabel.removeFromParent()
        let nextScene = MenuScene(size: scene!.size)
        let transition = SKTransition.fade(withDuration: 0.0)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene,transition: transition)
    }
    func personalScore(){
        // Personal Score label
        personalLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.2)
        personalLabel.fontSize = 20
        let personalScoreTitle = NSLocalizedString("personalScore", comment: "My comment")
        personalLabel.text = "\(personalScoreTitle):" // make a score that increases
        personalLabel.name = "highScoreLabel"
        personalLabel.zPosition = 100
        addChild(personalLabel)
        //Highscore Score
        let highscoreTitle = NSLocalizedString("highscore", comment: "My comment")
        highScoreLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.1)
        highScoreLabel.fontSize = 15
        highScoreLabel.text = "\(highscoreTitle):\(highscoreArray)" // make a score that increases
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.zPosition = 100
        addChild(highScoreLabel)
        // Max Wave Label
        let waveTitle = NSLocalizedString("highlevel", comment: "My comment")
        waveLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.15)
        waveLabel.fontSize = 15
        waveLabel.text = "\(waveTitle):\(waveArray)" // make a score that increases
        waveLabel.name = "waveLabel"
        waveLabel.zPosition = 100
        addChild(waveLabel)
    }
    func setupLabels(){
        database.child("Highscore").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                return
            }
            print("Value:\(value)")
        })
        // Setting up a top 10 label
        let top10Title = NSLocalizedString("top10", comment: "My comment")
        top10Label.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.85)
        top10Label.fontSize = 20
        top10Label.text = "\(top10Title):" // make a score that increases
        top10Label.name = "waveLabel"
        top10Label.zPosition = 100
        addChild(top10Label)
        // Setting positions!
        UILabel1.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.8)
        UILabel2.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.75)
        UILabel3.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.70)
        UILabel4.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.65)
        UILabel5.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.60)
        UILabel6.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.55)
        UILabel7.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.50)
        UILabel8.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.45)
        UILabel9.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.4)
        UILabel10.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.35)
        // Setting Text!
        //eventually request for the data from firebase!
        UILabel1.text = "\(String(describing: value))"
        UILabel2.text = "Text 2"
        UILabel3.text = "Text 3"
        UILabel4.text = "Text 4"
        UILabel5.text = "Text 5"
        UILabel6.text = "Text 6"
        UILabel7.text = "Text 7"
        UILabel8.text = "Text 8"
        UILabel9.text = "Text 9"
        UILabel10.text = "Text 10"
        //Setting frame and location
        UILabel1.zPosition = 100
        UILabel2.zPosition = 100
        UILabel3.zPosition = 100
        UILabel4.zPosition = 100
        UILabel5.zPosition = 100
        UILabel6.zPosition = 100
        UILabel7.zPosition = 100
        UILabel8.zPosition = 100
        UILabel9.zPosition = 100
        UILabel10.zPosition = 100
        // Setting the font
        UILabel1.fontSize = 15
        UILabel2.fontSize = 15
        UILabel3.fontSize = 15
        UILabel4.fontSize = 15
        UILabel5.fontSize = 15
        UILabel6.fontSize = 15
        UILabel7.fontSize = 15
        UILabel8.fontSize = 15
        UILabel9.fontSize = 15
        UILabel10.fontSize = 15
        //adding the SKLabelnodes
        addChild(UILabel1)
        addChild(UILabel2)
        addChild(UILabel3)
        addChild(UILabel4)
        addChild(UILabel5)
        addChild(UILabel6)
        addChild(UILabel7)
        addChild(UILabel8)
        addChild(UILabel9)
        addChild(UILabel10)
    }
}
