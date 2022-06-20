//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class GameModel:ObservableObject {
    
    @Published var showGameOverView = false
    @Published var parameter = GameParameters()
    //環境値
    @Published var currentColor = MyColor()
    //初期値をiPhone 8の画面サイズで設定、ContentViewのonAppearの時に再読み込み
    @Published var screenBounds = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0)
    
    let triangleController = TriangleContloller()
    let itemController = ItemController()
    let baranceViewContloller = BaranceViewContloler()
    let score = PlayingScores()

    //シングルトン
    static let shared = GameModel()
    private init(){
        resetGame()
    }
    
    //ゲームのリセットに利用
    func resetGame() {
        //TODO: セーブデータのロード
        parameter.resetParameters()
        baranceViewContloller.reset()
        triangleController.resetParameters()
        itemController.resetParameters()
        currentColor = MyColor()
    }
    ///ステータスの更新とイベント処理を行う
    func updateGameParameters(deleteCount: Int) {
        //消去の数に応じてパラメーターの更新を行う
        let result = parameter.updateParameters(deleteCount: deleteCount)
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
            parameter.level += 1
            parameter.setParameters()
            triangleController.setParameters()
            currentColor.nextColor()
        }
    }
    func gameOver(){
        score.setScores()
        score.updateHiScore()
        withAnimation {
            showGameOverView = true
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
