//
//  BGMPlayer.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/03.
//

import Foundation
import AVFoundation

class BGMPlayer: ObservableObject {
    
    @Published var volumeScale: Float = 0.5 {
        didSet {
            SaveData.shared.saveData(value: BGMSetting(volumeScale: volumeScale, muted: muted))
        }
    }
    @Published var muted = false {
        didSet {
            SaveData.shared.saveData(value: BGMSetting(volumeScale: volumeScale, muted: muted))
        }
    }
    private var volume: Float {
        muted ? 0 : volumeScale * 0.4
    }
    //シングルトン
    static let shared = BGMPlayer()
    private init(){
        if let setting = SaveData.shared.loadData(type: BGMSetting.self) {
            self.volumeScale = setting.volumeScale
            self.muted = setting.muted
        }
        
    }
    
    private var stageBgm: (bgm: Bgm, player: AVAudioPlayer)?

    func play(bgm: Bgm) {
        guard let stageBgm = stageBgm else {
            start(bgm: bgm)
            return
        }
        guard stageBgm.bgm != bgm else {
            return
        }
        changeBgm(to: bgm)
    }
    
    func setVolume() {
        stageBgm?.player.setVolume(volume, fadeDuration: 0)
    }
    
    private var task: Task<Void, Error>?
    private func changeBgm(to bgm: Bgm) {
        if let task = task {
            task.cancel()
            self.task = nil
        }
        task = Task {
            stageBgm?.player.setVolume(0, fadeDuration: 0.8)
            //判定用のbgmプロパティを先に更新
            stageBgm?.bgm = bgm
            let waitTime: UInt64 = bgm == .ending ? 3000_000_000 : 1000_000_000
            do {
                try await Task.sleep(nanoseconds: waitTime)
                stageBgm?.player.stop()
                start(bgm: bgm)
            } catch {
                return
            }
        }
    }

    
    private func start(bgm: Bgm) {
        guard let url = Bundle.main.url(forResource: bgm.faileName, withExtension: "mp3") else {
            return
        }
        guard let player = try? AVAudioPlayer.init(contentsOf: url) else {
            return
        }
        player.numberOfLoops = -1
        player.volume = volume
        player.play()
        stageBgm = (bgm: bgm, player: player)
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
    
    struct BGMSetting: Codable {
        let volumeScale: Float
        let muted: Bool
    }
}
