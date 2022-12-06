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
    @Published var results: [ResultModel] = []
    private let soundPlayer = SEPlayer.shared
    
    private var gameModel: GameModel?
    private var subscriber: AnyCancellable?

    func depend(gameModel: GameModel) {
        guard self.gameModel == nil else {
            return
        }
        self.gameModel = gameModel
        subscriber = gameModel.gameEventPublisher
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
        guard let gameModel = gameModel else {
            return
        }
        
        let score = gameModel.stageScore
    
        results = [
            ResultModel(type: .stage, value: score.stage),
            ResultModel(type: .count, value: score.count),
            ResultModel(type: .combo, value: score.combo),
            ResultModel(type: .score, value: score.score),
        ]
        //ハイスコア読み込みおよび更新
        results.indices.forEach { index in
            let loadScore = SaveData.shared.loadData(name: results[index].type)
            results[index].setParameters(index: index, score: loadScore)
            if results[index].isUpdated {
                SaveData.shared.saveData(name: results[index].type, intValue: results[index].value )
            }
        }
        //totalPointの読み込みおよび更新
        let totalPoint = SaveData.shared.loadData(name: ResultValue.totalPoint) + score.score
        let totalPointIndex = results.count
        results.append(ResultModel(type: .totalPoint, value: totalPoint, index: totalPointIndex))
        SaveData.shared.saveData(name: ResultValue.totalPoint, intValue: totalPoint)
    }
   
    func loadTotalPointData() {
        results[4].value = SaveData.shared.loadData(name: ResultValue.totalPoint)
    }
    
    func playDecideSound() {
        soundPlayer.play(sound: .decideSound)
    }
    
    func closeResult() {
        guard let gameModel = gameModel else {
            return
        }
        soundPlayer.play(sound: .decideSound)
        gameModel.resetGame()
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
 
    mutating func setParameters(index: Int, score: Int) {
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
        case .totalPoint:
            return "Point"
        }
    }
}

enum ResultValue: CaseIterable, SaveDataName {
    case stage
    case count
    case combo
    case score
    case totalPoint
}
