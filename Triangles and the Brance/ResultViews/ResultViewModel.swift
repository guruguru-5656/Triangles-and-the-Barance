//
//  ScoreModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import SwiftUI

//スコアを表示用に加工して出力する
final class ResultViewModel: ObservableObject {
    @Published var results: [ResultModel] = ScoreType.allCases.enumerated().map {
        ResultModel(type: $0.element, index: $0.offset)
        }
    @Published var point = 0
    @Published var totalPoint = 0
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
    
    func setResultScores() {
        //TODO: 修正
//        for (index, value) in GameModel.shared.stageModel.getScore().enumerated() {
//            results[index].value = value
//        }
        results.indices.forEach{
            results[$0].isUpdated = false
        }
        totalPoint = SaveData.shareData.loadPointData()
    }
    func updateHiScore() {
        let hiScores = SaveData.shareData.loadHiScoreData()
        for index in results.indices {
            let hiScoreIndex = hiScores.firstIndex{
                $0.type == String(describing: results[index].type)
            }!
            if hiScores[hiScoreIndex].value < results[index].value {
                results[index].isUpdated = true
                hiScores[hiScoreIndex].value = Int64(results[index].value)
            }
        }
        SaveData.shareData.saveHiScoreData()
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
        case .point:
            return "Point"
        case .totalPoint:
            return "Total Point"
        }
    }
}

enum ScoreType: CaseIterable, SaveDataValue {
    case stage
    case count
    case combo
    case score
    case point
    case totalPoint
    
    var defaultValue: Int {
        return 0
    }
}
