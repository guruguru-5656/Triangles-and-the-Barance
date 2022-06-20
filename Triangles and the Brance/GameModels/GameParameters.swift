//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import Foundation

struct GameParameters {
   
    //ゲーム開始時に初期化するステータス
    var level:Int = 1
    var maxCombo = 0
    var allDeleteCount = 0
    var score = 0
    
    //ステージ開始時に初期化するステータス
    var life:Int = 5
    var deleteCount = 0
    var deleteCountNow = 0
    
    var targetDeleteCount: Int = 0
   
    //クリア率。これを監視して、ステージクリアを呼び出す
    var clearPersent: Double {
        var percent = Double(deleteCount) / Double(targetDeleteCount)
        if percent > 1 { percent = 1 }
        return percent
    }
    //ゲームの難易度に関わる定数
    var defaultLife = 5
    
    //ゲーム開始時に呼び出す
    mutating func resetParameters() {
        level = 1
        maxCombo = 0
        allDeleteCount = 0
        score = 0
        deleteCountNow = 0
        setParameters()
    }
    
    //ステージ開始時に呼び出す
    mutating func setParameters() {
        loadSaveData()
        life = defaultLife
        
        targetDeleteCount = level * 10 + 10
        deleteCount = 0
    }
    
    private mutating func loadSaveData() {
        let lifeData = SaveData.shareData.shareUpgradeData(type: .life)
        defaultLife = lifeData.level + 2
    }
    
    ///ステータスの更新とクリア判定、ゲームオーバー判定を行う
    mutating func updateParameters(deleteCount: Int) -> GameEvent{
        self.deleteCountNow = deleteCount
        self.deleteCount += deleteCount
        self.allDeleteCount += deleteCount
        self.score += deleteCount * deleteCount * level
        self.life -= 1
        SaveData.shareData.money += score
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
}
