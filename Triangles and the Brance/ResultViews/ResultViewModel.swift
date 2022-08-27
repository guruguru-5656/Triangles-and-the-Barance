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
    
    private var stageModel: StageModel?
    private var subscriber: AnyCancellable?
    @Published var results: [ResultModel] = []
    @Published var viewStatus: ViewStatus = .onAppear

    func depend(stageModel: StageModel) {
        guard self.stageModel == nil else {
            return
        }
        self.stageModel = stageModel
        subscribe()
    }
    
    func subscribe() {
        guard let stageModel = stageModel else {
            return
        }

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
    
    func showScores() {
        setResultScores()
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
        guard let stageModel = stageModel else {
            return
        }
        
        let log = stageModel.stageLogs
        
        let finalStage = log.reduce(0) {
            ($1.stage > $0 ? $1.stage : $0)
        }
        let count = log.reduce(0) {
            $0 + $1.deleteCount
        }
        let maxCombo = log.reduce(0) {
            ($1.maxCombo > $0 ? $1.maxCombo : $0)
        }
        let score = log.reduce(0) {
            $0 + $1.deleteCount * $1.maxCombo * $1.stage
        }
        let point = log.reduce(0) {
            $0 + $1.maxCombo * $1.deleteCount
        } * finalStage

        results = [
            ResultModel(type: .stage, value: finalStage),
            ResultModel(type: .count, value: count),
            ResultModel(type: .combo, value: maxCombo),
            ResultModel(type: .score, value: score),
            ResultModel(type: .point, value: point)
        ]
        //ハイスコア読み込みおよび更新
        results.indices.forEach { index in
            let loadScore = SaveData.shared.loadData(name: results[index].type)
            results[index].compareData(index: index, score: loadScore)
            if results[index].isUpdated {
                SaveData.shared.saveData(name: results[index].type, value: results[index].value )
            }
        }
        //totalPointの読み込みおよび更新
        let totalPoint = SaveData.shared.loadData(name: ResultValue.totalPoint) + point
        let totalPointIndex = results.count
        results.append(ResultModel(type: .totalPoint, value: totalPoint, index: totalPointIndex))
        SaveData.shared.saveData(name: ResultValue.totalPoint, value: totalPoint)
    }
   
    func loadTotalPointData() {

        results[5].value = SaveData.shared.loadData(name: ResultValue.totalPoint)
    }
    
    func closeResult() {
        guard let stageModel = stageModel else {
            return
        }
        stageModel.resetGame()
    }
}

struct ResultModel: Identifiable, Hashable {

    let type: ResultValue
    var value: Int = 0
    private (set) var isUpdated = false
    //アニメーション用の番号
    private (set) var index: Int = 0
    var viewStatus: ViewStatus = .isOff
    let id = UUID()
    
    init(type: ResultValue, value: Int, index: Int = 0) {
        self.type = type
        self.value = value
        self.index = index
    }
 
    mutating func compareData(index: Int, score: Int) {
        self.index = index
        isUpdated = score < value
    }
    
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

enum ResultValue: CaseIterable, SaveDataName {
    case stage
    case count
    case combo
    case score
    case point
    case totalPoint
}
