//
//  ScoreModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Combine
import SwiftUI

//スコアを表示用に加工して出力する
final class ResultViewModel: ObservableObject {
    
    init(stageModel: StageModel) {
        self.stageModel = stageModel
    }
    private let stageModel: StageModel
    private var subscriber: AnyCancellable?
    func subscribe() {
        subscriber = stageModel.gameEventPublisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .gameOver:
                    self.setResultScores()
                    self.showScores()
                    return
                default:
                    break
                }
            }
    }
    
    @Published var results: [ResultModel] = []
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
        let log = stageModel.stageLogs
      
        let count = log.reduce(0) {
            $0 + $1.deleteCount
        }
        
        let maxCombo = log.reduce(0) {
            ($1.maxCombo > $0 ? $1.maxCombo : $0)
        }
        let score = log.reduce(0) {
            $0 + $1.deleteCount * $1.maxCombo
        } * log.count
        let point = log.reduce(0) {
            $1.maxCombo * $1.deleteCount + $1.stage
        }

        results = [
            ResultModel(type: .stage, value: log.count),
            ResultModel(type: .count, value: count),
            ResultModel(type: .combo, value: maxCombo),
            ResultModel(type: .score, value: score),
            ResultModel(type: .point, value: point)
            //TODO: totalPoint実装
        ]
//        totalPoint = SaveData.shareData.loadPointData()
    }
//    func updateHiScore() {
//        let hiScores = SaveData.shareData.loadHiScoreData()
//        for index in results.indices {
//            let hiScoreIndex = hiScores.firstIndex{
//                $0.type == String(describing: results[index].type)
//            }!
//            if hiScores[hiScoreIndex].value < results[index].value {
//                results[index].isUpdated = true
//                hiScores[hiScoreIndex].value = Int64(results[index].value)
//            }
//        }
//        SaveData.shareData.saveHiScoreData()
//    }
    func closeResult() {
        stageModel.resetGame()
    }
}

struct ResultModel: Identifiable, Hashable {
    init(type: ScoreType, value: Int) {
        self.type = type
        self.value = value
    }
    
    let id = UUID()
    //アニメーションや配列の検索にindexを利用
    let index: Int = 0
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

enum ScoreType: CaseIterable, SaveDataName {
    case stage
    case count
    case combo
    case score
    case point
    case totalPoint
}
