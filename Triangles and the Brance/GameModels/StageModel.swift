//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import Foundation

class StageModel:ObservableObject {
   
    @Published var showResultView = false
    //ゲーム開始時に初期化するステータス
    @Published var level = 1
    @Published var maxCombo = 0
    @Published var allDeleteCount = 0
    @Published var score = 0
    @Published var money = 0
    //ステージ開始時に初期化するステータス
    @Published var life:Int = 5
    @Published var deleteCount = 0
    @Published var targetDeleteCount: Int = 0
    //ゲームの難易度に関わる定数
    var defaultLife = 5
    //ゲーム開始時に呼び出す
    func resetGame() {
        level = 1
        maxCombo = 0
        allDeleteCount = 0
        score = 0
        setParameters()
    }
    
    //ステージ開始時に呼び出す
    func setParameters() {
        loadSaveData()
        life = defaultLife
        targetDeleteCount = level * 10 + 10
        deleteCount = 0
    }
    
    private func loadSaveData() {
        let lifeData = SaveData.shareData.loadUpgradeData().first {
            $0.type == .life
        }!
        defaultLife = lifeData.level + 2
        money = SaveData.shareData.loadMoneyData()
    }
    
    ///ステータスの更新とクリア判定、ゲームオーバー判定を行う
    func updateParameters(deleteCount: Int) -> GameEvent{
        GameModel.shared.baranceViewContloller.deleteCountNow = deleteCount
        self.deleteCount += deleteCount
        self.allDeleteCount += deleteCount
        self.score += deleteCount * deleteCount * level
        self.life -= 1
        money += deleteCount * level
        if self.maxCombo < deleteCount {
            maxCombo = deleteCount
        }
        if self.deleteCount >= targetDeleteCount {
            return .stageClear
        }
        if life == 0{
            return .gameOver
        }
        return .nothing
    }
    
    func saveData() {
        SaveData.shareData.saveMoneyData(money: money)
    }
}
