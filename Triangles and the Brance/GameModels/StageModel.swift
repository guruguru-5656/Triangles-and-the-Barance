//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import SwiftUI
import Combine

class StageModel: ObservableObject {
 
    @Published var showResultView = false
    @Published var stage: Int
    @Published var deleteCount: Int = 0
    @Published var life: Int
    private var maxLife = 3
    private var maxCombo: Int = 0
    //目標値
    var targetDeleteCount: Int {
        targetList[stage - 1]
    }
    private let targetList = [10, 15, 20, 25, 30, 35, 40, 45, 50,  55, 60, 70]
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
                //TODO: GameClear
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
        withAnimation {
            showResultView = true
        }
        //データを初期状態でセーブ
        SaveData.shared.saveData(name: StageState.stage, value: 1)
        let initialLog: [StageData] = []
        SaveData.shared.saveData(name: StageLog.log, value: initialLog)
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
}

enum GameEvent {
    case initialize
    case triangleDeleted
    case clearAnimation
    case stageClear
    case gameOver
    case resetGame
}

enum StageState: SaveDataName {
    case stage
}

enum StageLog: SaveDataName {
    case log
}
