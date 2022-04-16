//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class GameModel:ObservableObject{
    //TriangleおよびItemのプロパティ
    
    @Published var triangles: [TriangleViewModel] = []
    @Published var actionItems:[ActionItemModel] = []
    @Published var selectedActionItem:ActionItemModel?
    @Published var showGameOverView = false
    @Published var parameter = GameParameters()
    
    @Published var currentColor = MyColor()
    //初期値をiPhone 8の画面サイズで設定、ContentViewのonAppearの時に再読み込み
    @Published var screenBounds = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0)
    let baranceViewContloller = BaranceViewContloler()
    let score = PlayingScores()
    let upgradeModel = UpgradeViewModel()
    
    var defaultParameters = DefaultParameters()
    ///外側の配列がY軸、内側の配列がX軸を表す
    private var triangleArrengement: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    //ゲームのリセットに利用
    func resetGame() {
        //TODO: セーブデータのロード
        parameter.resetParameters(defaultParameter: defaultParameters)
        baranceViewContloller.reset()
        setTrianglesStatus()
        setStageActionItems()
        upgradeModel.setItemsParent()
        currentColor = MyColor()
    }
    static let shared = GameModel()
    
    private init(){
        setStageTriangles()
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
        baranceViewContloller.clearAnimation {
            self.parameter.level += 1
            self.parameter.setParameters(defaultParameter: self.defaultParameters)
            self.setTrianglesStatus()
            self.currentColor.nextColor()
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
    ///三角形のビューのセットアップ
    private func setStageTriangles(){
        for (triangleY, arrangement) in triangleArrengement.enumerated(){
            for triangleX in arrangement{
                let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOff, action: nil )
                triangles.append(triangleModel)
            }
        }
    }
    ///triangleに一定確率でアイテムをセット
    private func setTrianglesStatus(){
        for index in triangles.indices {
            let random:Double = Double.random(in:1...100)
            if random <= parameter.triangleIsOnProbability {
                triangles[index].status = .isOn
                let randomNumber:Double = Double.random(in:1...100)
                if randomNumber <= parameter.triangleHaveActionProbability {
                    //MARK: 変更予定
                    triangles[index].actionItem = ActionItemModel(action: .triforce)
                }
            }else{
                triangles[index].status = .isOff
            }
        }
    }
    ///ステージにItemの描画をセットする
    private func setStageActionItems() {
        actionItems = []
    }
    
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
