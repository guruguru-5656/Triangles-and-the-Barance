//
//  BGMPlayer.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/09/07.
//

import Foundation
import AVFoundation

class BGMPlayer {
    private var player: AVAudioPlayer?
    func prepare() {
        guard let url = Bundle.main.url(forResource: "simpleBGM", withExtension: "mp3") else {
                  return
              }
        player = try? AVAudioPlayer.init(contentsOf: url)
        player?.prepareToPlay()
    }
    init?(name: String) {
//        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
//            return nil
//        }
//        guard let path = Bundle.main.path(forResource: name, ofType: "mp3")
//            else {
//            print("Failed to cleate soundID")
//            return nil
//        }
//        let url = NSURL.fileURL(withPath: path)
//        guard let player = try? AVAudioPlayer.init(contentsOf: url) else {
//            return nil
//        }
//        self.player = player
//        self.player.prepareToPlay()
    }
    func play() {
        player?.numberOfLoops = -1
        player?.play()
    }
}
