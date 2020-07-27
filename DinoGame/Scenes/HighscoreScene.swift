//
//  HighscoreScene.swift
//  DinoGame
//
//  Created by Jordan Klein on 7/19/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import Foundation

import SpriteKit
import GameKit

class HighscoreScene: SKScene, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("Finished?")
    }
    
    // Creasting personal labels here
    let highScoreLabel = SKLabelNode(fontNamed: "Press Start 2P")
    let waveLabel = SKLabelNode(fontNamed: "Press Start 2P")
    let personalLabel = SKLabelNode(fontNamed: "Press Start 2P")
    let top10Label = SKLabelNode(fontNamed: "Press Start 2P")
    
    let leaderboardButton = UIButton()
    let levelLeaderBoardButton = UIButton()
    let achievementButton = UIButton()
    
    
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
        backbutton() // adds back button
        background() // adds background
        personalScore() // personal score without any firebase!
        gameCenter() // loading in game center stuff
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
        highScoreLabel.removeFromParent()
        waveLabel.removeFromParent()
        let nextScene = MenuScene(size: scene!.size)
        let transition = SKTransition.fade(withDuration: 0.0)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene,transition: transition)
    }
    func personalScore() {
        // Personal Score label
        personalLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.8)
        personalLabel.fontSize = 20
        let personalScoreTitle = NSLocalizedString("personalScore", comment: "My comment")
        personalLabel.text = "\(personalScoreTitle):" // make a score that increases
        personalLabel.name = "highScoreLabel"
        personalLabel.zPosition = 100
        addChild(personalLabel)
        //Highscore Score
        let highscoreTitle = NSLocalizedString("highscore", comment: "My comment")
        highScoreLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.7)
        highScoreLabel.fontSize = 15
        highScoreLabel.text = "\(highscoreTitle):\(highscoreArray)" // make a score that increases
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.zPosition = 100
        addChild(highScoreLabel)
        // Max Wave Label
        let waveTitle = NSLocalizedString("highlevel", comment: "My comment")
        waveLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.75)
        waveLabel.fontSize = 15
        waveLabel.text = "\(waveTitle):\(waveArray)" // make a score that increases
        waveLabel.name = "waveLabel"
        waveLabel.zPosition = 100
        addChild(waveLabel)
    }
    func gameCenter() {
        // Button to view leaderboard!
        leaderboardButton.frame = CGRect (x:frame.midX - 200, y:screenHeight * 0.4, width: 400, height: 50)
        let leaderboardtitle = NSLocalizedString("leaderboard", comment: "My comment")
        leaderboardButton.setTitle(leaderboardtitle, for: UIControl.State.normal)
        leaderboardButton.titleLabel?.numberOfLines = 2
        leaderboardButton.setTitleColor(UIColor.white, for: .normal)
        leaderboardButton.backgroundColor = .clear
        leaderboardButton.layer.cornerRadius = 10
        leaderboardButton.layer.borderWidth = 2
        leaderboardButton.layer.borderColor=UIColor.white.cgColor
        leaderboardButton.addTarget(self, action: #selector(leaderboardPushed), for: UIControl.Event.touchUpInside)
        leaderboardButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 15)
        leaderboardButton.titleLabel!.textAlignment = NSTextAlignment.center
        leaderboardButton.backgroundColor = customGreen
        self.view!.addSubview(leaderboardButton)
        // Button to view highest levels!
        levelLeaderBoardButton.frame = CGRect (x:frame.midX - 200, y:screenHeight * 0.5, width: 400, height: 50)
        let wavetitle = NSLocalizedString("waveBoard", comment: "My comment")
        levelLeaderBoardButton.setTitle(wavetitle, for: UIControl.State.normal)
        levelLeaderBoardButton.setTitleColor(UIColor.white, for: .normal)
        levelLeaderBoardButton.backgroundColor = .clear
        levelLeaderBoardButton.layer.cornerRadius = 10
        levelLeaderBoardButton.layer.borderWidth = 2
        levelLeaderBoardButton.layer.borderColor=UIColor.white.cgColor
        levelLeaderBoardButton.addTarget(self, action: #selector(achievementPushed), for: UIControl.Event.touchUpInside)
        levelLeaderBoardButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 15)
        levelLeaderBoardButton.titleLabel!.textAlignment = NSTextAlignment.center
        levelLeaderBoardButton.backgroundColor = customGreen
        self.view!.addSubview(levelLeaderBoardButton)
        // Button to view achievements!
        achievementButton.frame = CGRect (x:frame.midX - 200, y:screenHeight * 0.6, width: 400, height: 50)
        let achievementtitle = NSLocalizedString("achievement", comment: "My comment")
        achievementButton.setTitle(achievementtitle, for: UIControl.State.normal)
        achievementButton.setTitleColor(UIColor.white, for: .normal)
        achievementButton.backgroundColor = .clear
        achievementButton.layer.cornerRadius = 10
        achievementButton.layer.borderWidth = 2
        achievementButton.layer.borderColor=UIColor.white.cgColor
        achievementButton.addTarget(self, action: #selector(achievementPushed), for: UIControl.Event.touchUpInside)
        achievementButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 15)
        achievementButton.titleLabel!.textAlignment = NSTextAlignment.center
        achievementButton.backgroundColor = customGreen
        self.view!.addSubview(achievementButton)
    }
    
    @objc func leaderboardPushed(){
        let storyboard = UIStoryboard(name: "leaderboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "leaderboard")
        vc.view.frame = (self.view?.frame)!
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: self.view!, duration: 0.0, options: .transitionFlipFromBottom, animations: {
            self.view?.window?.rootViewController = vc
        }, completion: { completed in
            
        })
    }
    @objc func achievementPushed(){
        let storyboard = UIStoryboard(name: "waveleaderboard", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "waveleaderboard")
               vc.view.frame = (self.view?.frame)!
               vc.view.layoutIfNeeded()
               
               UIView.transition(with: self.view!, duration: 0.0, options: .transitionFlipFromBottom, animations: {
                   self.view?.window?.rootViewController = vc
               }, completion: { completed in
                   
               })
    }
}
