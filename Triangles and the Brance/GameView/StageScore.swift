//
//  StageScore.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/29.
//

import Foundation

struct StageScore: Codable {
    var stage: Int
    var score: Int
    var count: Int
    var combo: Int
    var scoreDifference: Int = 0
    //通常の初期化の際はこちらを使用
    init() {
        self.stage = 1
        self.score = 0
        self.combo = 0
        self.count = 0
    }
    //初期値を設定しての初期化の際に使用
    init(stage: Int, score: Int, count: Int, combo: Int) {
        self.stage = stage
        self.score = score
        self.count = count
        self.combo = combo
    }
    
    mutating func triangleDidDeleted(count: Int) {
        self.count += count
        scoreDifference = Self.calculateScore(count: count, stage: stage)
        score += scoreDifference
        if combo < count {
            combo = count
        }
    }
    
    mutating func stageUpdate(_ stage: Int) {
        self.stage = stage
    }
    
    static func calculateScore(count: Int, stage: Int) -> Int {
        return Int(Double(count) * chainBonus(count) * stageBonus(stage))
    }
    
    static private func chainBonus(_ count: Int) -> Double {
        return 1 + 0.5 * Double(count)
    }
    
    static private func stageBonus(_ stage: Int) -> Double {
        return 1 + 0.2 * Double(stage)
    }
}
