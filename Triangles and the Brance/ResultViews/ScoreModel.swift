//
//  ScoreModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import SwiftUI

//スコアを表示用に加工して出力する
final class PlayingScores: ObservableObject {
    @Published var showUpgrade = false
    @Published var results: [ResultModel] = ScoreType.allCases.enumerated().map {
        ResultModel(type: $0.element, index: $0.offset)
        }
    @Published var money = SaveData.shareData.money
    @Published var viewStatus: ViewStatus = .onAppear
    
    func showScores() {
        viewStatus = .onAppear
        withAnimation(.easeIn(duration: 3)){
        viewStatus = .isOn
        }
        results.indices.forEach { index in
            withAnimation(.linear(duration: 0.1).delay(10 + Double(index) * 0.3)){
                results[index].viewStatus = .onAppear
            }
            withAnimation(.linear(duration: 0.2).delay(10 + Double(index) * 0.3 + 0.1)){
                results[index].viewStatus = .isOn
            }
        }
    }
    
    func setScores() {
        results[0].value = GameModel.shared.parameter.level
        results[1].value = GameModel.shared.parameter.deleteCount
        results[2].value = GameModel.shared.parameter.maxCombo
        results[3].value = GameModel.shared.parameter.score
        results.indices.forEach{
            results[$0].isUpdated = false
        }
        money = SaveData.shareData.money
    }
    
    func updateHiScore() {
        //SaveData内のデータを更新
        for index in results.indices {
            let hiScoreIndex = SaveData.shareData.hiScores.firstIndex{
                $0.type == results[index].type
            }!
            if SaveData.shareData.hiScores[hiScoreIndex].value < results[index].value {
                SaveData.shareData.hiScores[hiScoreIndex].value = results[index].value
                results[index].isUpdated = true
            }
        }
    }
}

struct ResultModel: Identifiable, Hashable {
    init(type: ScoreType, index: Int) {
        self.type = type
        if type == .stage {
            self.value = 1
        }
        self.index = index
    }
    
    let id = UUID()
    //アニメーションや配列の検索にindexを利用
    let index: Int
    var viewStatus: ViewStatus = .isOff
    
    let type: ScoreType
    var value: Int = 0
    var isUpdated = false
    
    var text: String {
        switch type {
        case .stage:
            return "Stage"
        case .count:
            return "Count"
        case .combo:
            return "Max Combo"
        case .score:
            return "Score"
        }
    }
}

enum ScoreType: CaseIterable {
    case stage
    case count
    case combo
    case score
}
