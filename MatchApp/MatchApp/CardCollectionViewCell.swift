//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Ulugbek Yusupov on 1/18/19.
//  Copyright © 2019 Ulugbek Yusupov. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        
        //keep of track of the card that gets passed in
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched == true {
            
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else {
            
            backImageView.alpha = 1
            frontImageView.alpha = 1
            
        }
        
        if card.isFlipped == true {
            
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        }
        else {
            
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        }
        
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove() {
        
        //removes both imageViews being visible
        //TODO: Animate it
        
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options:.curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
        
    }
}
