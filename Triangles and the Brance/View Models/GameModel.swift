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
    @Published var actionItems:[ActionItemModel] = []
    @Published var selectedActionItem:ActionItemModel?
    //ステージのパラメータをまとめたクラス
    @Published var parameters = GameParameters(level: 1)
    //Gameのパラメータ
    @Published var stageLevel:Int = 1
    
    @Published var clearPercent:Double = 0
    @Published var deleteCount = 0{
       
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
    
    init(){
        //初期化時にステージの構造を生成
        setStageParameters()
        setStageTriangles()
        setTrianglesStatus()
        setStageActionItems()
    }
    func stageClear(){
        stageLevel += 1
        parameters = GameParameters(level: stageLevel)
        setStageParameters()
        setTrianglesStatus()
        currentColor.nextColor()
    }
    func setStageParameters(){
        deleteCount = 0
        clearPercent = 0
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
            if random <= parameters.probabilityOfTriangleIsOn {
                triangles[index].status = .isOn
                let randomNumber:Double = Double.random(in:1...100)
                if randomNumber <= parameters.probabilityOfTriangleHaveAction {
                    triangles[index].actionItem = ActionItemModel(action: .triforce, status: .onAppear)
                }
            }else{
                triangles[index].status = .isOff
            }
        }
    }
    ///ステージにItemの描画をセットする
    private func setStageActionItems() {
        //TODO: 前のステージで持っていたアイテムを引き継ぐ
//        actionItems.append(contentsOf: [ActionItemModel(action: .normal, status: .onAppear)])
    }
    ///タップしたときのアクションを呼び出す
    func triangleTapAction(index: Int) {
        if triangles[index].status == .isOn{
            let action = TriangleTapAction(stage: self)
            action.trianglesTapAction(index: index)
        }else{
            //アイテムが入っていた場合はtrianglesにセット
            if let selectedItem = selectedActionItem{
                switch selectedItem.action{
                case .normal:
                    guard parameters.normalActionCount != 0 else{
                        print("カウントゼロの状態にもかかわらず、ノーマルアクションが入っている")
                        return
                    }
                    parameters.normalActionCount -= 1
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
                    actionItems.remove(at: indexOfItem)
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

class GameParameters: ObservableObject{
    init(level: Int){
        self.life = (now: 5, max: 5)
        self.deleteTriangleCount = (now: 0, target: 20 + level * 5)
        self.normalActionCount = (now: 3, max: 3)
        self.probabilityOfTriangleIsOn = baseProbabilityOfTriangleIsOn
        self.probabilityOfTriangleHaveAction = baseProbabilityOfTriangleHaveAction +
        Double(level)
    }
    
    var life: (now: Int, max: Int) = (now: 5, max: 5)
    var deleteTriangleCount:(now: Int, target: Int)
    var normalActionCount:(now: Int, max: Int)

    //Triangleの生成時に参照するパラメータ、現状probabilityOfTrianglesIsOnについては未計算のまま
    //TODO: minimamNumberOfTriangleIsOnを使用したステージの生成
    fileprivate var probabilityOfTriangleIsOn:Double
    fileprivate var minimamNumberOfTriangleIsOn:Int = 20
    fileprivate var probabilityOfTriangleHaveAction:Double
    
    
    private let baseProbabilityOfTriangleIsOn:Double = 40
    private let baseProbabilityOfTriangleHaveAction:Double = 0
}
