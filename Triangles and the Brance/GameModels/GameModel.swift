//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//


import Combine

//依存関係を定義し、ViewModelを保持するクラス
class GameModel {
  
    let stageModel: StageModel
    let triangleController: TriangleContloller
    let itemController: ItemController
    let baranceViewModel: BaranceViewModel
    let score = ResultViewModel()
    let viewEnvironment: ViewEnvironment
    //シングルトン
    static let shared = GameModel()
    private init() {
        //インスタンス生成
    
        stageModel = StageModel()
        itemController = ItemController(stageModel: stageModel)
        triangleController = TriangleContloller(stageModel: stageModel, itemController: itemController)
        baranceViewModel = BaranceViewModel(stageModel: stageModel)
        viewEnvironment = ViewEnvironment(stageModel: stageModel)
        //イベントの発行を監視
        triangleController.subscribe()
        baranceViewModel.subscribe()
        itemController.subscribe()
        viewEnvironment.subscribe()
        //データのロード
        
        //初期化処理
        triangleController.setParameters()
        itemController.setParameters()
    }
   
    func gameOver() {
        score.setResultScores()
        score.updateHiScore()
        score.showScores()
    }
}

