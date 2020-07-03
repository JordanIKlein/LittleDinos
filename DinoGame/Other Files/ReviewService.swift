//
//  ReviewService.swift
//  DinoGame
//
//  Created by Jordan Klein on 6/10/20.
//  Copyright © 2020 JordanKlein. All rights reserved.
//

import Foundation
import StoreKit

class ReviewService {
    
    private init() {}
    static let shared = ReviewService()
    
    private let defaults = UserDefaults.standard
    
    private var lastRequest: Date? { // date we are saving, optional date
        get{
            return defaults.value(forKey: "ReviewService.lastRequest") as? Date
        }
        set{
            defaults.set(newValue, forKey: "ReviewService.lastRequest")
        }
    }
    
    private var oneWeekAgo: Date { // has it been over a week since we last asked?
        return Calendar.current.date(byAdding: .day, value:-7, to:Date())!
    }
    
    private var shouldRequestReview:Bool {
        if lastRequest == nil {
            return true
        } else if let lastRequest = self.lastRequest, lastRequest < oneWeekAgo {
            return true
        }
        return false
    }
    
    func requestReview(){
        guard shouldRequestReview else {return}
        SKStoreReviewController.requestReview()
        lastRequest = Date()
    }
    
}
