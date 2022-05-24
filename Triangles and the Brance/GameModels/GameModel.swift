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
    let upgradeModel = UpgradeViewModel()
    
    var defaultParameters = DefaultParameters()
    ///外側の配列がY軸、内側の配列がX軸を表す
    
    //ゲームのリセットに利用
    func resetGame() {
        //TODO: セーブデータのロード
        parameter.resetParameters(defaultParameter: defaultParameters)
        baranceViewContloller.reset()
        triangleController.resetParameters(defaultParameter: defaultParameters)
        itemController.resetParameters(defaultParameter: defaultParameters)
        upgradeModel.setItemsParent()
        currentColor = MyColor()
    }
    static let shared = GameModel()
    
    private init(){
        resetGame()
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
            parameter.setParameters(defaultParameter: defaultParameters)
            triangleController.setParameters(defaultParameter: defaultParameters)
            currentColor.nextColor()
        }
    }
    func gameOver(){
        score.setScores()
        score.updateHiScore()
        upgradeModel.setPreviousStatus()
        withAnimation {
            showGameOverView = true
        }
        score.showScores()
    }
   
    //ステージの構造生成
  
   
}

enum StageError:Error{
    case isNotExist
    case triangleIndexError
}

protocol PlayingData {
    mutating func resetParameters(defaultParameter: DefaultParameters)
    mutating func setParameters(defaultParameter: DefaultParameters)
}

enum GameEvent {
    case nothing
    case stageClear
    case gameOver
}
