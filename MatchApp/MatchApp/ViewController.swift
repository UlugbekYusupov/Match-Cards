//
//  ViewController.swift
//  MatchApp
//
//  Created by Ulugbek Yusupov on 1/18/19.
//  Copyright © 2019 Ulugbek Yusupov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Float = 50 * 1000 //10seconds
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:.common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
    }
    //MARK: Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if milliseconds <= 0 {
            
            //stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    
    //MARK: UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //get the card that CollectionView is trying to display
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //stop when timer is 0 and make unable to select cards
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //get the card that user selected
        let card = cardArray[indexPath.row]
        
        
        if card.isFlipped == false && card.isMatched == false {
            //flip the card
            cell.flip()
            
            //play the flip sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            //determine if it's first or second card that's flipped
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            }
            else {
                //perform the matching logic
                checkForMatches(indexPath)
            }
        }
    }// end didSelectItemAt method
    
    //MARK: Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        
        //compare two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //it is a match
            
            SoundManager.playSound(.match)
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove the card from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //check if there are any cards left unmatched
            checkGameEnded()
        }
        else {
            
            // it is not a match
            SoundManager.playSound(.nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip both cards back
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //tell the collectioview to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        //determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        //if not then user has won, stop the timer
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've won"
        }
        else {
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        //show alert message
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert,animated: true, completion: nil)
        
    }
} // end of ViewController class

