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
    var point: Int {
        Int(Double(score) * (1 + 0.2 * Double(stage)))
    }
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
        score += Int(Double(count) * (1 + 0.5 * Double(count)))
        if combo < count {
            combo = count
        }
    }
    
    mutating func stageUpdate(_ stage: Int) {
        self.stage = stage
    }
}
