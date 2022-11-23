//
//  SoundPlayer.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/17.
//

import Foundation
import AVFoundation

class BGMPlayer {
    //シングルトン
    static let instance = BGMPlayer()
    private let volume: Float = 0.5
    private init(){
    }
    
    private var stageBgm: AVAudioPlayer?

    func play(bgm: Bgm){
        if stageBgm?.isPlaying ?? false {
            changeBgm(to: bgm)
            return
        }
        start(bgm: bgm)
    }
    
    private var task: Task<(), Error>?
    private func changeBgm(to bgm: Bgm) {
        if let task = task {
            task.cancel()
            self.task = nil
        }
        task = Task {
            stageBgm?.setVolume(0, fadeDuration: 0.8)
            let waitTime: UInt64 = bgm == .ending ? 3000_000_000 : 1000_000_000
            do {
                try await Task.sleep(nanoseconds: waitTime)
                stageBgm?.stop()
                start(bgm: bgm)
            } catch {
                print(error)
                return
            }
        }
    }
    
    private func start(bgm: Bgm) {
        guard let url = Bundle.main.url(forResource: bgm.faileName, withExtension: "mp3") else {
            return
        }
        self.stageBgm = try? AVAudioPlayer.init(contentsOf: url)
        stageBgm?.numberOfLoops = -1
        stageBgm?.setVolume(volume, fadeDuration: 0)
        stageBgm?.play()
    }
    
    enum Bgm {
        case title
        case stage
        case gameOver
        case ending
        var faileName: String {
            switch self {
            case .title:
                return "titleBGM"
            case .stage:
                return "stageBGM"
            case .gameOver:
                return "gameOverBGM"
            case .ending:
                return  "endingBGM"
            }
        }
    }
}

class SoundPlayer: NSObject {
    //シングルトン
    static let instance = SoundPlayer()
    private override init(){
        super.init()
        prepareAllSounds()
    }
    
    private var effectSounds: [String:AVAudioPlayer] = [:]
    
    func play(sound: Sound) {
        guard let player = effectSounds[sound.rawValue] else {
            print("効果音再生失敗")
            return
        }
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        player.play()
    }
    
    func prepareAllSounds() {
        Sound.allCases.forEach { sound in
            let fileName = sound.rawValue
            do {
                let player = try loadFile(name: fileName)
                effectSounds.updateValue(player, forKey: fileName)
                effectSounds[fileName]!.prepareToPlay()
            } catch {
                print(error)
            }
        }
    }
    
    func loadFile(name: String) throws -> AVAudioPlayer {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            throw SetupError.couldNotFindUrl
        }
        guard let player = try? AVAudioPlayer.init(contentsOf: url) else {
            throw SetupError.couldNotInitAudioPlayer
        }
        return player
    }
    
    enum Sound: String, CaseIterable {
        case selectSound, itemUsed, clearSound, marimba_1, marimba_2, marimba_3, marimba_4, marimba_5, marimba_6, marimba_7, marimba_8, upgradeSound, cancelSound, decideSound, restartSound, gameOverSound
    }
    
    fileprivate enum SetupError: Error {
        case couldNotFindUrl
        case couldNotInitAudioPlayer
    }
}
