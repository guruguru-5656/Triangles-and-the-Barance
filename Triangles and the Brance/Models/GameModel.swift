//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class GameModel:ObservableObject{
    //TriangleおよびItemのプロパティ
    @Published var currentColor = MyColor()
    @Published var triangles: [TriangleViewModel] = []
    @Published var actionItems:[ActionItemViewModel] = []
    @Published var selectedActionItem:ActionItemViewModel?
    @Published var showGameOverView = false
    
    @Published var parameter = GameParameters()
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
        setTrianglesStatus()
        setStageActionItems()
        upgradeModel.setItemsParent()
    }
    static let shared = GameModel()
    
    private init(){
        setStageTriangles()
        resetGame()
    }
    
    ///ステータスの更新とイベント処理を行う
    func updateGameParameters(deleteCount: Int) {
        switch parameter.updateParameters(deleteCount: deleteCount) {
        case .nothing:
            return
        case .stageClear:
            stageClear()
        case .gameOver:
            gameOver()
        }
    }
    
    func stageClear(){
        parameter.level += 1
        parameter.setParameters(defaultParameter: defaultParameters)
        setTrianglesStatus()
        currentColor.nextColor()
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
                    triangles[index].actionItem = ActionItemViewModel(action: .triforce, status: .onAppear)
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
    ///タップしたときのアクションを呼び出す
    func triangleTapAction(index: Int) {
        if triangles[index].status == .isOn{
            parameter.life -= 1
            let action = TriangleTapAction(gameModel: self)
            action.trianglesTapAction(index: index)
        }else{
            //アイテムが入っていた場合はtrianglesにセット
            if let selectedItem = selectedActionItem{
                switch selectedItem.action{
                case .normal:
                    guard parameter.normalActionCount != 0 else{
                        print("カウントゼロの状態にもかかわらず、ノーマルアクションが入っている")
                        return
                    }
                    parameter.normalActionCount -= 1
                    selectedActionItem = nil
                    triangles[index].status = .isOn
                case .triforce:
                    let indexOfItem = actionItems.firstIndex {
                        $0.id == selectedItem.id
                    }
                    guard let indexOfItem = indexOfItem else {
                        print("アイテムのインデックス取得エラー")
                        return
                    }
                    //removeに戻り値が発生してしまい警告が出るためアンダースコアに代入
                    _ = withAnimation{
                    actionItems.remove(at: indexOfItem)
                    }
                    triangles[index].actionItem = selectedItem
                    selectedActionItem = nil
                    triangles[index].status = .isOn
                }
            }
        }
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
