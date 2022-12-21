//
//  SoundPlayer.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/17.
//

import Foundation
import AVFoundation


class SEPlayer: ObservableObject {
    
    @Published var volumeScale: Float = 0.5 {
        didSet {
            SaveData.shared.saveData(value: SESetting(volumeScale: volumeScale, muted: muted))
        }
    }
    @Published var muted = false  {
        didSet {
            SaveData.shared.saveData(value: SESetting(volumeScale: volumeScale, muted: muted))
        }
    }
    private var volume: Float {
        muted ? 0 : volumeScale
    }
    
    //シングルトン
    static let shared = SEPlayer()
    private init() {
        if let setting = SaveData.shared.loadData(type: SESetting.self) {
            self.volumeScale = setting.volumeScale
            self.muted = setting.muted
        }
        prepareAllSounds()
    }
    
    private var effectSounds: [String:AVAudioPlayer] = [:]
    
    func play(sound: Sound) {
        guard let player = effectSounds[sound.rawValue] else {
            print("効果音再生失敗")
            return
        }
        if player.isPlaying {
            //効果音を重複して再生するための一時的なplayerを生成
            let duplicatedPlayer = DuplicatedPlayer(sound: sound, volume: volume, handler: removeDuplicatedPlayer(id:))
            duplicatedPlayers.updateValue(duplicatedPlayer, forKey: duplicatedPlayer.id)
        }
        player.play()
    }
    
    func play(sound: Sound, delay: Double) {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000 * UInt64(delay * 1000))
            play(sound: sound)
        }
    }
    
    func prepareAllSounds() {
        Sound.allCases.forEach { sound in
            let fileName = sound.rawValue
            do {
                let player = try loadFile(name: fileName)
                effectSounds.updateValue(player, forKey: fileName)
                effectSounds[fileName]!.prepareToPlay()
                effectSounds[fileName]!.volume = self.volume
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
    
    func setVolume() {
        effectSounds.forEach { (key, _) in
            effectSounds[key]!.setVolume(volume, fadeDuration: 0)
        }
    }
    
    //効果音が重複されて呼び出された時に一時的に生成
    private var duplicatedPlayers: [UUID:DuplicatedPlayer] = [:]
    
    private func removeDuplicatedPlayer(id: UUID) {
        duplicatedPlayers.removeValue(forKey: id)
    }
    
    private class DuplicatedPlayer: NSObject, AVAudioPlayerDelegate {
        let id = UUID()
        var player: AVAudioPlayer?
        var handler: (UUID) -> Void = {_ in }
        var volume: Float = 0
        
        init(sound: Sound, volume: Float, handler: @escaping (UUID) -> Void) {
            super.init()
            player = try? loadFile(name: sound.rawValue)
            self.volume = volume
            self.handler = handler
            player?.delegate = self
            player?.play()
        }
        
        private func loadFile(name: String) throws -> AVAudioPlayer {
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
                throw SetupError.couldNotFindUrl
            }
            guard let player = try? AVAudioPlayer.init(contentsOf: url) else {
                throw SetupError.couldNotInitAudioPlayer
            }
            return player
        }
        
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            handler(id)
        }
    }
    
    enum Sound: String, CaseIterable {
        case selectSound, itemUsed, clearSound, marimba_1, marimba_2, marimba_3, marimba_4, marimba_5, marimba_6, marimba_7, marimba_8, upgradeSound, cancelSound, decideSound,  gameOverSound
    }
    
    fileprivate enum SetupError: Error {
        case couldNotFindUrl
        case couldNotInitAudioPlayer
    }
    
    struct SESetting: Codable {
        let volumeScale: Float
        let muted: Bool
    }
}
