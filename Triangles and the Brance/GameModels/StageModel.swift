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
    var targetDeleteCount:Int {
        targetList[stage - 1]
    }
    private let targetList = [10, 15, 20, 25, 30, 35, 40, 45, 50,  55, 60, 70]
    //スコアの生成に利用
    private (set) var stageLogs: [StageLog] = []
    //イベントの発行
    private(set) var gameEventPublisher = PassthroughSubject<GameEvent, Never>()

    init() {
        //TODO: データロード
        stage = 1
        maxLife = 3
        
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
        createLog()
        gameOver()
    }
    
    func resetGame() {
        stage = 1
        //TODO: データロード
        maxLife = 3
       
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
                resetStageParameter()
                gameEventPublisher.send(.stageClear)
            }
        }
    }
    
    private func gameOver() {
        gameEventPublisher.send(.gameOver)
        createLog()
        withAnimation {
            showResultView = true
        }
    }
    
    private func resetStageParameter() {
        deleteCount = 0
        maxCombo = 0
        life = maxLife
        stageLogs = []
    }
    
    private func createLog() {
        let log = StageLog(stage: stage, deleteCount: deleteCount, maxCombo: maxCombo)
        stageLogs.append(log)
    }
}

//テスト用メソッド
extension StageModel {
    func setLog(logs: [StageLog]) {
        self.stageLogs = logs
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
