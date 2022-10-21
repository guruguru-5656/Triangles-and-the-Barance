//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import SwiftUI
import Combine
import AVFoundation

class StageModel: ObservableObject {
    
    @Published var showResultView = false
    @Published var isGameClear = false
    @Published var stage: Int
    @Published var deleteCount: Int = 0
    @Published var life: Int
    private var maxLife = 3
    private var maxCombo: Int = 0
    //目標値
    var targetDeleteCount: Int {
        targetList[stage - 1]
    }
    private let targetList = [10, 15, 20, 25, 30, 36, 43, 50, 57, 63, 70, 80]
    //スコアの生成に利用
    private (set) var stageLogs: [StageData] = []
    //イベントの発行
    private(set) var gameEventPublisher = PassthroughSubject<GameEvent, Never>()
    
    init() {
        let stageData = SaveData.shared.loadData(name: StageState.stage)
        stage = stageData == 0 ? 1 : stageData
        maxLife = SaveData.shared.loadData(name: UpgradeType.life) + 2
        stageLogs = SaveData.shared.loadData(name: StageLog.log, valueType: Array<StageData>.self) ?? []
        life = maxLife
    }
    
    func updateParameters(deleteCount: Int) {
        self.deleteCount += deleteCount
        self.life -= 1
        if self.maxCombo < deleteCount {
            maxCombo = deleteCount
        }
        gameEventPublisher.send(.triangleDeleted)
        //イベントの判定
        if self.deleteCount >= targetDeleteCount {
            if stage == 12 {
                gameClear()
                return
            } else {
                stageClear()
                return
            }
        }
        if life == 0 {
            gameOver()
        }
    }
    
    func giveUp() {
        gameOver()
    }
    
    func resetGame() {
        stage = 1
        maxLife = SaveData.shared.loadData(name: UpgradeType.life) + 2
        resetStageParameter()
        gameEventPublisher.send(.resetGame)
        withAnimation {
            showResultView = false
        }
        withAnimation {
            isGameClear = false
        }
        changeBgm(to: .stage)
    }
    
    private func stageClear() {
        gameEventPublisher.send(.clearAnimation)
        Task {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                createLog()
                stage += 1
                deleteCount = 0
                maxCombo = 0
                life = maxLife
                saveStageStatus()
                gameEventPublisher.send(.stageClear)
            }
        }
    }
    
    private func gameOver() {
        createLog()
        gameEventPublisher.send(.gameOver)
        gameOverSound?.play()
        changeBgm(to: .gameOver)
        withAnimation {
            showResultView = true
        }
        //データを初期状態でセーブ
        SaveData.shared.saveData(name: StageState.stage, value: 1)
        let initialLog: [StageData] = []
        SaveData.shared.saveData(name: StageLog.log, value: initialLog)
    }
    
    private func gameClear() {
        isGameClear = true
        gameEventPublisher.send(.gameClear)
        
        changeBgm(to: .ending)
        //データを初期状態でセーブ
        SaveData.shared.saveData(name: StageState.stage, value: 1)
        let initialLog: [StageData] = []
        SaveData.shared.saveData(name: StageLog.log, value: initialLog)
        Task {
            try await Task.sleep(nanoseconds: 3000_000_000)
            await MainActor.run {
                withAnimation {
                    showResultView = true
                }
                createLog()
                saveStageStatus()
            }
        }
    }
    
    private func resetStageParameter() {
        deleteCount = 0
        maxCombo = 0
        life = maxLife
        stageLogs = []
    }
    
    private func createLog() {
        let log = StageData(stage: stage, deleteCount: deleteCount, maxCombo: maxCombo)
        stageLogs.append(log)
    }
    
    private func saveStageStatus() {
        SaveData.shared.saveData(name: StageState.stage, value: stage)
        SaveData.shared.saveData(name: StageLog.log, value: stageLogs)
    }
    //SE再生
    private var gameOverSound = EffectSoundPlayer(name: "gameOverSound")
    
    //BGM再生
    private var stageBgm: AVAudioPlayer?
    
    func startBgm(){
        if stageBgm?.isPlaying ?? false {
            return
        }
        play(bgm: .stage)
    }
    
    private func changeBgm(to bgm: Bgm) {
        stageBgm?.setVolume(0, fadeDuration: 1)
        Task {
            let waitTime: UInt64 = bgm == .ending ? 3000_000_000 : 1000_000_000
            try await Task.sleep(nanoseconds: waitTime)
            await MainActor.run {
                stageBgm?.stop()
                play(bgm: bgm)
            }
        }
    }
    
    private func play(bgm: Bgm) {
        guard let url = Bundle.main.url(forResource: bgm.faileName, withExtension: "mp3") else {
            return
        }
        self.stageBgm = try? AVAudioPlayer.init(contentsOf: url)
        
        stageBgm?.numberOfLoops = -1
        stageBgm?.play()
    }
    
    private enum Bgm {
        case stage
        case gameOver
        case ending
        var faileName: String {
            switch self {
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

enum GameEvent {
    case triangleDeleted
    case clearAnimation
    case stageClear
    case gameOver
    case gameClear
    case resetGame
}

enum StageState: SaveDataName {
    case stage
}

enum StageLog: SaveDataName {
    case log
}

struct StageData:Codable, Hashable {
    let stage: Int
    let deleteCount: Int
    let maxCombo: Int
}
