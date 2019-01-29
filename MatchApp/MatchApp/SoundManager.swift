//
//  SoundManager.swift
//  MatchApp
//
//  Created by Ulugbek Yusupov on 1/22/19.
//  Copyright © 2019 Ulugbek Yusupov. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect: SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
            
        case .flip:
            soundFileName = "cardflip"
            
        case .shuffle:
            soundFileName = "shuffle"
            
        case .match:
            soundFileName = "dingcorrect"
            
        case .nomatch:
            soundFileName = "dingwrong"
        }
        
        //get the sound file in the sound bundle
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't file sound file \(soundFileName) in the bundle")
            return
        }
        
        //create a URL object from this path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do {
            //create audioPlayer object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create the audio player object for sound file \(soundFileName)")
        }
    }
}
