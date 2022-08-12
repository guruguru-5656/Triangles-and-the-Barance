//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class GameModel{
  
    let stageModel: StageModel
    let triangleController: TriangleContloller
    let itemController: ItemController
    let score = ScoreModel()
    let viewEnvironment = ViewEnvironment()

    //シングルトン
    static let shared = GameModel()
    private init(){
        stageModel = StageModel()
        triangleController = TriangleContloller()
        itemController = ItemController()
        resetGame()
    }
    
    //ゲームのリセットに利用
    func resetGame() {
        //TODO: セーブデータのロード
        stageModel.resetGame()
        triangleController.resetGame()
        itemController.resetGame()
        viewEnvironment.resetGame()
    }
    ///ステータスの更新とイベント処理を行う
    func updateGameParameters(deleteCount: Int) {
        //消去の数に応じてパラメーターの更新を行う
        let result = stageModel.updateParameters(deleteCount: deleteCount)
       
        switch result {
        case .nothing:
            return
        case .stageClear:
            stageClear()
        case .gameOver:
            gameOver()
        }
    }
    func stageClear(){
        stageModel.clearAnimation()
        Task {
            try await Task.sleep(nanoseconds: 1000000000)
            await MainActor.run {
            stageModel.level += 1
            stageModel.setParameters()
            triangleController.setParameters()
            itemController.prepareForNextStage()
            viewEnvironment.stageClear()
            }
        }
    }
    func gameOver(){
        stageModel.saveData()
        score.setResultScores()
        score.updateHiScore()
        withAnimation {
            stageModel.showResultView = true
        }
        score.showScores()
    }
}


enum GameEvent {
    case nothing
    case stageClear
    case gameOver
}
