//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import SwiftUI

class StageModel:ObservableObject {
    
    @Published var showResultView = false
    //ゲーム開始時に初期化するステータス
    @Published var level = 1 {
        didSet {
            targetDeleteCount = targetList[level - 1]
        }
    }
    private let targetList = [10, 15, 20, 25, 30, 35, 40, 45, 50,  55, 60, 70]
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
        angle = Double.pi/16
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
        self.deleteCount += deleteCount
        self.totalDeleteCount += deleteCount
        self.score += deleteCount * deleteCount * level
        self.life -= 1
        if self.maxCombo < deleteCount {
            maxCombo = deleteCount
        }
        //アニメーションを実行
        baranceAnimation()
        showTextAnimation(count: deleteCount)
        hiLightAnimation()
        //イベントの判定
        if self.deleteCount >= targetDeleteCount {
            if level == 12 {
                return .gameOver
            } else {
                return .stageClear
            }
        }
        if life == 0 {
            return .gameOver
        }
        return .nothing
    }
    
    func saveData() {
        point = totalDeleteCount * level
        totalPoint += point
        SaveData.shareData.savePointData(point: totalPoint)
    }
    
  
    //天秤の角度のアニメーション
    private let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.5)
    @Published var angle: Double = Double.pi/16
    func baranceAnimation() {
        let clearPersent = Double(deleteCount) / Double(targetDeleteCount) > 1 ? 1 : Double(deleteCount) / Double(targetDeleteCount)
        withAnimation(angleAnimation) {
            angle = (1 - clearPersent) * Double.pi/16
        }
    }
    
    @Published var isTriangleHiLighted = false
    func hiLightAnimation() {
        withAnimation {
            isTriangleHiLighted = true
        }
        Task {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                withAnimation {
                    isTriangleHiLighted = false
                }
            }
        }
    }
    
    //テキストを一時的に表示するアニメーション
    @Published var deleteCountNow = 0
    @Published var showDeleteCountText = false
    func showTextAnimation(count: Int) {
        deleteCountNow = count
        withAnimation {
            showDeleteCountText = true
        }
        Task {
            try await Task.sleep(nanoseconds: 800_000_000)
            await MainActor.run {
                withAnimation {
                    showDeleteCountText = false
                }
            }
        }
    }
    
    //クリア時のアニメーション
    @Published var clearCircleIsOn = false
    func clearAnimation() {
        Task {
            await MainActor.run {
                withAnimation(.timingCurve(0.3, 0.2, 0.7, 0.4, duration: 0.5)) {
                    angle = -0.5 * Double.pi/16
                }
            }
            try await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    clearCircleIsOn = true
                }
            }
            try await Task.sleep(nanoseconds: 600_000_000)
            await MainActor.run {
                self.clearCircleIsOn = false
                withAnimation(.easeOut(duration: 0.5)) {
                    angle = Double.pi/16
                }
            }
        }
    }
}
