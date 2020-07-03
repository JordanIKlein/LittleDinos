//
//  Shop.swift
//  DinoGame
//
//  Created by Jordan Klein on 7/1/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

//Localizing Strings for pop up notifications here
let purpleTitle = NSLocalizedString("purpleAsteroid", comment: "My comment")
let redTitle = NSLocalizedString("redAsteroid", comment: "My comment")
let blueTitle = NSLocalizedString("blueAsteroid", comment: "My comment")
let greenTitle = NSLocalizedString("greenAsteroid", comment: "My comment")
let specialTitle = NSLocalizedString("specialAsteroid", comment: "My comment")
// Unlockables
let purpleUnlockable = NSLocalizedString("purpleUnlockable", comment: "My comment")
let redUnlockable = NSLocalizedString("redUnlockable", comment: "My comment")
let blueUnlockable = NSLocalizedString("blueUnlockable", comment: "My comment")
let greenUnlockable = NSLocalizedString("greenUnlockable", comment: "My comment")
let specialUnlockable = NSLocalizedString("specialUnlockable", comment: "My comment")

// Remove Ads Button
let removeAdButton = UIButton(type: .system)
// Making an Asteroid User Default
var asteroid = UserDefaults.standard.string(forKey: "texture") ?? "asteroid1"
// Declaring Buttons Public
let buttonNumber1 = UIButton(type: .custom)
let buttonNumber2 = UIButton(type: .custom)
let buttonNumber3 = UIButton(type: .custom)
let buttonNumber4 = UIButton(type: .custom)
let buttonNumber5 = UIButton(type: .custom)
let buttonNumber6 = UIButton(type: .custom)
// User Defaults for unlockables
var blueSkin = UserDefaults.standard.bool(forKey: "blue")
var redSkin = UserDefaults.standard.bool(forKey: "red")
var greenSkin = UserDefaults.standard.bool(forKey: "green")
var purpleSkin = UserDefaults.standard.bool(forKey: "purple")
var mixSkin = UserDefaults.standard.bool(forKey: "mix")
// Creating labels for below the buttons
let blueLabel = SKLabelNode(fontNamed: "Press Start 2P")
let redLabel = SKLabelNode(fontNamed: "Press Start 2P")
let greenLabel = SKLabelNode(fontNamed: "Press Start 2P")
let purpleLabel = SKLabelNode(fontNamed: "Press Start 2P")
let mixLabel = SKLabelNode(fontNamed: "Press Start 2P")

class ShopScene: SKScene, Alertable{
    override func didMove(to view: SKView) {
        for view in view.subviews {
            if view is UIButton{
                view.removeFromSuperview()
            } else {
                view.removeFromSuperview()
            }
        }
    
    // Adding in Custom UI Buttons to purchase new asteroid with Stars
    addingShopBackground()
    buttonsForBackground()
    labels()
    run(SKAction.repeatForever(SKAction.sequence([SKAction.run{self.buttonBackgrounds()
        }, SKAction.wait(forDuration: 0.01)])))
    self.backgroundColor = .black
    }
    func addingShopBackground(){
        //Star Textures behind
        if let particles = SKEmitterNode(fileNamed: "Stars"){
            particles.position = CGPoint(x: -10, y: screenHeight)
            particles.zPosition = -1000
            particles.advanceSimulationTime(60)
            addChild(particles)
        }
        starLabel.position = CGPoint(x: screenWidth * 0.5, y: screenHeight * 0.75)
        starLabel.fontSize = 15
        starLabel.name = "starLabel"
        starLabel.zPosition = 3
        starLabel.physicsBody?.isDynamic = false
        addChild(starLabel)
    }
    func buttonBackgrounds(){
        // Checking the star count
        starLabel.text = "\(starTitle):\(collectedStars)"
        buttonNumber1.backgroundColor = .white
        buttonNumber2.backgroundColor = .white
        buttonNumber3.backgroundColor = .white
        buttonNumber4.backgroundColor = .white
        buttonNumber5.backgroundColor = .white
        buttonNumber6.backgroundColor = .white
        if asteroid == "asteroid1"{
            buttonNumber1.backgroundColor = .link
        } else if asteroid == "asteroid2" {
            buttonNumber2.backgroundColor = .link
        } else if asteroid == "asteroid3" {
            buttonNumber3.backgroundColor = .link
        } else if asteroid == "asteroid4" {
            buttonNumber4.backgroundColor = .link
        } else if asteroid == "asteroid5" {
            buttonNumber5.backgroundColor = .link
        } else if asteroid == "asteroid6" {
            buttonNumber6.backgroundColor = .link
        }
    }
    func labels(){
        if blueSkin == false {
            blueLabel.fontSize = 10
            blueLabel.position = CGPoint(x: buttonNumber3.frame.origin.x + 50, y: buttonNumber3.frame.origin.y - 120)
            blueLabel.text = "100 \(starTitle)"
            blueLabel.zPosition = 100
            print("added blue label")
            addChild(blueLabel)
        } else {
           
        }
        if greenSkin == false {
            greenLabel.fontSize = 10
            greenLabel.position = CGPoint(x: buttonNumber6.frame.origin.x + 50, y: buttonNumber6.frame.origin.y - 120)
            greenLabel.text = "50 \(starTitle)"
            addChild(greenLabel)
        } else {
     
        }
        if redSkin == false {
            redLabel.fontSize = 10
            redLabel.position = CGPoint(x: buttonNumber4.frame.origin.x + 50, y: buttonNumber4.frame.origin.y - 120)
            redLabel.text = "150 \(starTitle)"
            addChild(redLabel)
        } else {
        
        }
        if purpleSkin == false {
            purpleLabel.fontSize = 10
            purpleLabel.position = CGPoint(x: buttonNumber1.frame.origin.x + 50, y: buttonNumber1.frame.origin.y - 120)
            purpleLabel.text = "200 \(starTitle)"
            addChild(purpleLabel)
        } else {
         
        }
        if mixSkin == false {
            mixLabel.fontSize = 10
            mixLabel.position = CGPoint(x: buttonNumber2.frame.origin.x + 50, y: buttonNumber2.frame.origin.y - 120)
            mixLabel.text = "250 \(starTitle)"
            addChild(mixLabel)
        } else {
            return
        }
    }
    func buttonsForBackground() {
        // MARK: Back Button
        backButton.frame = CGRect (x: Int(frame.width/2 - 100), y:Int(screenHeight * 0.05), width: 200, height: 40)
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
        
        // MARK: Remove Ads Button
        if !UserDefaults.standard.bool(forKey: "adsRemoved") {
            //self.view!.addSubview(removeAdButton)
        } else {
            
        }
        
        // MARK: Asteroid Buttons
        
        //Default Asteroid
        buttonNumber1.setImage(UIImage(named: "as"), for: .normal)
        buttonNumber1.frame = CGRect(x: Int(frame.width)/2 - 150, y: Int(screenHeight * 0.25), width: 100, height: 100)
        buttonNumber1.layer.cornerRadius = 20
        buttonNumber1.layer.borderWidth = 2
        buttonNumber1.addTarget(self, action: #selector(asteroid1), for: UIControl.Event.touchUpInside)
        self.view!.addSubview(buttonNumber1)
        // Asteroid 2
        buttonNumber2.setImage(UIImage(named: "asGreen"), for: .normal)
        buttonNumber2.frame = CGRect(x: Int(frame.width)/2 + 50, y: Int(screenHeight * 0.25), width: 100, height: 100)
  
        buttonNumber2.layer.cornerRadius = 20
        buttonNumber2.layer.borderWidth = 2
        buttonNumber2.addTarget(self, action: #selector(asteroid2), for: UIControl.Event.touchUpInside)
        self.view!.addSubview(buttonNumber2)
        // Asteroid 3
        buttonNumber3.setImage(UIImage(named: "asBlue"), for: .normal)
        buttonNumber3.frame = CGRect(x: Int(frame.width)/2 - 150, y: Int(screenHeight * 0.5), width: 100, height: 100)
  
        buttonNumber3.layer.cornerRadius = 20
        buttonNumber3.layer.borderWidth = 2
        buttonNumber3.addTarget(self, action: #selector(asteroid3), for: UIControl.Event.touchUpInside)
        self.view!.addSubview(buttonNumber3)
        // Asteroid 4
        buttonNumber4.setImage(UIImage(named: "asRed"), for: .normal)
        buttonNumber4.frame = CGRect(x: Int(frame.width)/2 + 50, y: Int(screenHeight * 0.5), width: 100, height: 100)
    
        buttonNumber4.layer.cornerRadius = 20
        buttonNumber4.layer.borderWidth = 2
        buttonNumber4.addTarget(self, action: #selector(asteroid4), for: UIControl.Event.touchUpInside)
        self.view!.addSubview(buttonNumber4)
        // Asteroid 5
        buttonNumber5.setImage(UIImage(named: "asPurple"), for: .normal)
        buttonNumber5.frame = CGRect(x: Int(frame.width)/2 - 150, y: Int(screenHeight * 0.75), width: 100, height: 100)
 
        buttonNumber5.layer.cornerRadius = 20
        buttonNumber5.layer.borderWidth = 2
        buttonNumber5.addTarget(self, action: #selector(asteroid5), for: UIControl.Event.touchUpInside)
        self.view!.addSubview(buttonNumber5)
        // Asteroid 6
        buttonNumber6.setImage(UIImage(named: "asMix"), for: .normal)
        buttonNumber6.frame = CGRect(x: Int(frame.width)/2 + 50, y: Int(screenHeight * 0.75), width: 100, height: 100)
 
        buttonNumber6.layer.cornerRadius = 20
        buttonNumber6.layer.borderWidth = 2
        buttonNumber6.addTarget(self, action: #selector(asteroid6), for: UIControl.Event.touchUpInside)
        self.view!.addSubview(buttonNumber6)
    }
    @objc func backbuttonRun(sender: UIButton!) {
        removeAllActions()
        removeAllChildren()
        let nextScene = MenuScene(size: scene!.size)
        let transition = SKTransition.fade(withDuration: 0.0)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene,transition: transition)
    }
    
    //asteroid 1
    @objc func asteroid1(sender: UIButton!) {
        asteroid = "asteroid1"
        UserDefaults.standard.set(asteroid,forKey: "texture")
    }
    //asteroid Green
    @objc func asteroid2(sender: UIButton!) {
        if greenSkin == false {
            if collectedStars >= 50 {
                asteroid = "asteroid2"
                UserDefaults.standard.set(asteroid,forKey: "texture")
                collectedStars = collectedStars - 50
                UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
                greenSkin = true
                UserDefaults.standard.set(true, forKey: "green")
                greenLabel.removeFromParent()
            } else {
                showAlert(withTitle: "\(greenTitle)!", message: "\(greenUnlockable)")
            }
        } else {
            asteroid = "asteroid2"
            UserDefaults.standard.set(asteroid,forKey: "texture")
        }
        
    }
    //asteroid Blue
    @objc func asteroid3(sender: UIButton!) {
        if blueSkin == false {
            if collectedStars >= 100 {
                asteroid = "asteroid3"
                UserDefaults.standard.set(asteroid,forKey: "texture")
                collectedStars = collectedStars - 100
                UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
                blueSkin = true
                UserDefaults.standard.set(true, forKey: "blue")
                blueLabel.removeFromParent()
            } else {
                showAlert(withTitle: "\(blueTitle)!", message: "\(blueUnlockable)")
            }
        } else {
            asteroid = "asteroid3"
            UserDefaults.standard.set(asteroid,forKey: "texture")
        }
    }
    //asteroid Red
    @objc func asteroid4(sender: UIButton!) {
        if redSkin == false {
            if collectedStars >= 150 {
                asteroid = "asteroid4"
                UserDefaults.standard.set(asteroid,forKey: "texture")
                collectedStars = collectedStars - 150
                UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
                redSkin = true
                UserDefaults.standard.set(true, forKey: "red")
                redLabel.removeFromParent()
            } else {
                showAlert(withTitle: "\(redTitle)!", message: "\(redUnlockable)")
            }
        } else {
            asteroid = "asteroid4"
            UserDefaults.standard.set(asteroid,forKey: "texture")
        }
    }
    //asteroid Purple
    @objc func asteroid5(sender: UIButton!) {
        if purpleSkin == false {
            if collectedStars >= 200 {
                asteroid = "asteroid5"
                UserDefaults.standard.set(asteroid,forKey: "texture")
                collectedStars = collectedStars - 200
                UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
                purpleSkin = true
                UserDefaults.standard.set(true, forKey: "purple")
                purpleLabel.removeFromParent()
            } else {
                showAlert(withTitle: "\(purpleTitle)!", message: "\(purpleUnlockable)")
            }
        } else {
            asteroid = "asteroid5"
            UserDefaults.standard.set(asteroid,forKey: "texture")
        }
    }
    //asteroid Special
    @objc func asteroid6(sender: UIButton!) {
        if mixSkin == false {
            if collectedStars >= 250 {
                asteroid = "asteroid6"
                UserDefaults.standard.set(asteroid,forKey: "texture")
                collectedStars = collectedStars - 250
                UserDefaults.standard.setValue(collectedStars, forKey: "starcollection")
                mixSkin = true
                UserDefaults.standard.set(true, forKey: "mix")
                mixLabel.removeFromParent()
            } else {
                showAlert(withTitle: "\(specialTitle)!", message: "\(specialUnlockable)")
            }
        } else {
            asteroid = "asteroid6"
            UserDefaults.standard.set(asteroid,forKey: "texture")
        }
    }
    
    
}
