//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class GameModel{
  
    let stageModel = StageModel()
    let triangleController = TriangleContloller()
    let itemController = ItemController()
    let baranceViewContloller = BaranceViewContloler()
    let score = ScoreModel()
    let viewEnvironment = ViewEnvironment()

    //シングルトン
    static let shared = GameModel()
    private init(){
        resetGame()
    }
    
    //ゲームのリセットに利用
    func resetGame() {
        //TODO: セーブデータのロード
        stageModel.resetGame()
        baranceViewContloller.resetGame()
        triangleController.resetGame()
        itemController.resetGame()
        viewEnvironment.resetGame()
    }
    ///ステータスの更新とイベント処理を行う
    func updateGameParameters(deleteCount: Int) {
        //消去の数に応じてパラメーターの更新を行う
        let result = stageModel.updateParameters(deleteCount: deleteCount)
        //アニメーションを実行
        baranceViewContloller.baranceAnimation()
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
        baranceViewContloller.clearAnimation { [self] in
            stageModel.level += 1
            stageModel.setParameters()
            triangleController.setParameters()
            itemController.setParameters()
            viewEnvironment.stageClear()
        }
    }
    func gameOver(){
        score.setResultScores()
        score.updateHiScore()
        withAnimation {
            stageModel.showGameOverView = true
        }
        score.showScores()
    }
}

enum StageError:Error{
    case isNotExist
    case triangleIndexError
}

enum GameEvent {
    case nothing
    case stageClear
    case gameOver
}
