//
//  EffectSound.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/09/07.
//

import Foundation
import AudioToolbox

class EffectSoundPlayer {
    init?(name:String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Failed to cleate soundID")
            return nil
        }
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            
    }
    private var soundID: SystemSoundID = 0
    
    func play() {
        AudioServicesPlaySystemSound(soundID)
    }
}
