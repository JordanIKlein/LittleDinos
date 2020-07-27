//
//  Leaderboard.swift
//  DinoGame
//
//  Created by Jordan Klein on 7/24/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import Foundation
import UIKit
import GameKit

class leaderboardClass: UIViewController, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("Finished")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        vc.view.frame = (self.view?.frame)!
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: self.view!, duration: 0.0, options: .transitionFlipFromBottom, animations: {
            self.view?.window?.rootViewController = vc
        }, completion: { completed in
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = "highscoredinos"
        present(vc, animated: true, completion: nil)
    }
}

class waveleaderboardClass: UIViewController, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        print("Finished")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        vc.view.frame = (self.view?.frame)!
        vc.view.layoutIfNeeded()
        
        UIView.transition(with: self.view!, duration: 0.0, options: .transitionFlipFromBottom, animations: {
            self.view?.window?.rootViewController = vc
        }, completion: { completed in
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = "wavedinos"
        present(vc, animated: true, completion: nil)
    }
}
