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
    @Published var totalDeleteCount = 0
    @Published var score = 0
    var totalPoint = 0
    var point = 0
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
        totalDeleteCount = 0
        score = 0
        point = 0
        setParameters()
    }
    
    //ステージ開始時に呼び出す
    func setParameters() {
        loadSaveData()
        life = defaultLife
        targetDeleteCount = targetList[level - 1]
        deleteCount = 0
    }
    func getScore() -> [Int] {
        return [ level, totalDeleteCount, maxCombo, score, point, totalPoint ]
    }
    private func loadSaveData() {
        let lifeData = SaveData.shareData.loadUpgradeData().first {
            $0.type == .life
        }!
        defaultLife = lifeData.level + 2
        totalPoint = SaveData.shareData.loadPointData()
    }
    
    ///ステータスの更新とクリア判定、ゲームオーバー判定を行う
    func updateParameters(deleteCount: Int) -> GameEvent{
        GameModel.shared.baranceViewContloller.deleteCountNow = deleteCount
        self.deleteCount += deleteCount
        self.totalDeleteCount += deleteCount
        self.score += deleteCount * deleteCount * level
        self.life -= 1
        if self.maxCombo < deleteCount {
            maxCombo = deleteCount
        }
        if self.deleteCount >= targetDeleteCount {
            if level == 12 {
                return .gameOver
            } else {
                return .stageClear
            }
        }
        if life == 0{
            return .gameOver
        }
        return .nothing
    }
    
    func saveData() {
        point = totalDeleteCount * level
        totalPoint += point
        SaveData.shareData.savePointData(point: totalPoint)
    }
    private let targetList = [10, 15, 20, 25, 30, 35, 40, 45, 50,  55, 60, 70]
}
