//
//  GameViewController.swift
//  DinoGame
//
//  Created by Jordan Klein on 6/7/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//


/*
 Music:
 Link: https://www.youtube.com/watch?v=KxwUy2S2n-Q
 ::::::::::::::::::::
 Music: Summer - Bensound
 https://www.bensound.com
 Support by RFM - NCM: https://bit.ly/2xGHypM
 ::::::::::::::::::::
 I have not changed this music in any way shape or form.
 
 */
// Admob Stuff
// App ID: ca-app-pub-4042774315695176~2576824278
// Interstitial ID: ca-app-pub-4042774315695176~2576824278
// ID: ca-app-pub-4042774315695176/3315190877
//
// Better Interstitial ID: ca-app-pub-4042774315695176/7881055601
// Rewarded Video ID: ca-app-pub-4042774315695176/1104443001

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import AVKit
import GameKit

let rewardedAdsButton = UIButton()
//Advertisement
var interstitial: GADInterstitial!

class GameViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver, GADRewardBasedVideoAdDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    var rewardedAd: GADRewardedAd?
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("You got the reward")
        collectedStars = collectedStars + 25
        UserDefaults.standard.set(collectedStars, forKey: "starcollection")
    }
    
    
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad presented.")
    }
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("dismissed")
    }
    
    var myProduct: SKProduct?
    
    var AudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-4042774315695176/1104443001")
        runningNotifications() // Notifications within the app
        //fetchProducts() // fetching products
        requestingInterstitialAD() // Requests Ad
        //initializingRemoveAdsButton() //Button to remove ads
        runningMusic() //Running background Music
        logInGameCenter()//
        if let view = self.view as! SKView? { // setting the view to an SKScene
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
    }
    
    private func logInGameCenter(){
        let player = GKLocalPlayer.local
        player.authenticateHandler = {vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            if let vc = vc {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    //Requesting requesting Interstitial AD
    func requestingInterstitialAD(){
        //Ad ID
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4042774315695176/7881055601")
        let request = GADRequest()
        interstitial.load(request)
    }
    //Notifications
    func runningNotifications(){
       //Ad Notificaiton
        NotificationCenter.default.addObserver(self, selector: #selector(createAndLoadInterstitial), name: .showInterstitialAd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadVideoRewardAd), name: .showVideoRewardAd, object: nil)
    }
    
    func runningMusic(){
        //Background Music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.volume = 0.05
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
    }
    // Interstitial Ad
    @objc func createAndLoadInterstitial(){
        if (interstitial.isReady){
            interstitial.present(fromRootViewController: self)
            interstitial = createAd()
        }
    }
    //Loading another Interstitial Ad
    func createAd() -> GADInterstitial{
        //loading a seperate Ad in the background
        let inter = GADInterstitial(adUnitID: "ca-app-pub-4042774315695176/7881055601")
        inter.load(GADRequest())
        return inter
    }
    //Video Reward AD
    @objc func loadVideoRewardAd(){
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            rewardedAdsButton.isEnabled = true
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        } else {
            GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-4042774315695176/1104443001")
        }
//        if rewardedAd?.isReady == true {
//           rewardedAd?.present(fromRootViewController: self, delegate:self)
//            rewardedAd = createReward()
//        }
    }
    //Loading another Interstitial Ad
    func createReward() -> GADRewardedAd{
        //loading a seperate Ad in the background
        let video = GADRewardedAd(adUnitID: "ca-app-pub-4042774315695176/1104443001")
        video.load(GADRequest())
        return video
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    
    
    //Remove Ads
//    func initializingRemoveAdsButton(){
//        removeAdButton.frame = CGRect (x: Int(screenWidth/2 - 150), y:Int(screenHeight * 0.15), width: 300, height: 45)
//        let removeAdsTitle = NSLocalizedString("removeAds", comment: "My comment")
//        removeAdButton.setTitle(removeAdsTitle, for: UIControl.State.normal)
//        removeAdButton.setTitleColor(UIColor.white, for: .normal)
//        removeAdButton.backgroundColor = customGreen
//        removeAdButton.layer.cornerRadius = 10
//        removeAdButton.layer.borderWidth = 1
//        removeAdButton.layer.borderColor=UIColor.white.cgColor
//        removeAdButton.addTarget(self, action: #selector(removeAdsButtonSender), for: UIControl.Event.touchUpInside)
//        removeAdButton.titleLabel!.font = UIFont(name: "Press Start 2P", size: 15)
//        removeAdButton.titleLabel!.textAlignment = NSTextAlignment.center
//    }
    // Remove Ads If Tapped
    // For a future update when Apple provides more capabilities for testing in app purchase... 
    //@objc func removeAdsButtonSender(sender: UIButton!) {
        //Remove Ads here
//        guard let myProduct = myProduct else {
//            print("returning")
//            return
//        }
//        if SKPaymentQueue.canMakePayments() {
//            print("Can make payment")
//            let payment = SKPayment(product: myProduct)
//            SKPaymentQueue.default().add(self)
//            SKPaymentQueue.default().add(payment)
//        }

    }
    
    
    //func fetchProducts(){
        //com.JordanKlein.DinoGame.removeads
//        let request = SKProductsRequest(productIdentifiers: ["com.JordanKlein.DinoGame.removeads"])
//        request.delegate = self
//        request.start()
   // }
    
    //func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //if the response contains our product
//        if let product = response.products.first {
//            myProduct = product
//            print(product.productIdentifier)
//            print(product.price)
//            print(product.localizedTitle)
//            print(product.localizedDescription)
//        }
    //}
    
   // func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .purchasing:
//                break
//            case .purchased, .restored:
//                //user has restored a purchase
//                //unlock item!
//                let alert = UIAlertController(title: "Ads Removed", message: "Payment Successful", preferredStyle: .alert)
//                self.present(alert, animated: true)
//                UserDefaults.standard.set(true, forKey: "adsRemoved")
//                SKPaymentQueue.default().finishTransaction(transaction)
//                SKPaymentQueue.default().remove(self)
//                break
//            case .failed, .deferred:
//                //user wasn't able to finish transaction
//                SKPaymentQueue.default().finishTransaction(transaction)
//                SKPaymentQueue.default().remove(self)
//                break
//            default:
//                SKPaymentQueue.default().finishTransaction(transaction)
//                SKPaymentQueue.default().remove(self)
//                break
//            }
//        }
    

