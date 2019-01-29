//
//  CardModel.swift
//  MatchApp
//
//  Created by Ulugbek Yusupov on 1/18/19.
//  Copyright © 2019 Ulugbek Yusupov. All rights reserved.
//

import Foundation

class CardModel {
    
    
    func getCards() -> [Card]{
        
        var generatedNumbersArray = [Int]()
        
        //declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        //randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            //get random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                print(randomNumber)
                
                generatedNumbersArray.append(Int(randomNumber))
                
                //create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                //create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
        }
        
        //randomize the array
        
        for i in 0...generatedCardsArray.count - 1 {
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            //swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        //return the array
        return generatedCardsArray
    }
        
}
