//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class GameModel:ObservableObject{
    @Published var currentColor = MyColor()
    @Published var triangles: [TriangleViewModel] = []
    @Published var actionItems:[ActionItemModel] = []
    @Published var selectedActionItem:ActionItemModel?
    @Published var stageLevel = 1
    @Published var life:Int
    @Published var clearPercent:Double
    var deleteCount = 0{
        didSet{
            clearPercent = Double(deleteCount) / Double(stageDifficulty.targetNumberOfDeleteTriangle)
            if clearPercent > 1 {
                clearPercent = 1
                stageClear()
            }
        }
    }
    func stageClear(){
        stageLevel += 1
        deleteCount = 0
        stageDifficulty = StageLevelManeger(level: stageLevel)
        setTrianglesStatus()
        currentColor.nextColor()
    }
    ///外側の配列がY軸、内側の配列がX軸を表す
    private var triangleArrengement: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    //ステージの難易度に関するプロパティをまとめたクラス
    private var stageDifficulty = StageLevelManeger(level: 1)
    init(){
        //初期化時にステージの構造を生成
        deleteCount = 0
        life = 5
        clearPercent = 0
        setStageTriangles()
        setTrianglesStatus()
        setStageActionItems()
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
    private func setTrianglesStatus(){
        for index in triangles.indices {
            let random:Double = Double.random(in:1...100)
            if random <= stageDifficulty.probabilityOfTriangleIsOn {
                triangles[index].status = .isOn
                let randomNumber:Double = Double.random(in:1...100)
                if randomNumber <= stageDifficulty.probabilityOfTriangleHaveAction {
                    triangles[index].action = .triforce
                }
            }else{
                triangles[index].status = .isOff
            }
        }
    }
    
   
    ///ステージにItemの描画をセットする
    private func setStageActionItems() {
        //TODO: 前のステージで持っていたアイテムを引き継ぐ
        actionItems.append(contentsOf: [ActionItemModel(action: .triforce)])
        actionItems.append(contentsOf: [ActionItemModel(action: .triforce)])
    }
    ///タップしたときのアクションを呼び出す
    func triangleTapAction(index: Int) {
        let action = TriangleTapAction(stage: self)
        action.trianglesTapAction(index: index)
    }
}

enum StageError:Error{
    case isNotExist
    case triangleIndexError
}
