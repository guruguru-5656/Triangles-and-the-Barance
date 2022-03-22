//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class StageModel:ObservableObject{
    
    @Published var currentColor = MyColor()
    @Published var triangles: [TriangleViewModel] = []
    @Published var actionItems:[ActionItemModel] = []
    @Published var selectedActionItem:ActionItemModel?
    
    ///外側の配列がY軸、内側の配列がX軸を表す
    private var triangleArrengement: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    
    ///ステージに引く線の配置
    private let lineArrangement:[(start:(x:Int,y:Int),end:(x:Int,y:Int))] = [
        ((2,0),(5,0)),((1,1),(5,1)), ((0,2),(5,2)), ((-1,3),(5,3)), ((-1,4),(4,4)), ((-1,5),(3,5)),((-1,6),(2,6)),
        ((-1,3),(-1,6)),((0,2),(0,6)), ((1,1),(1,6)), ((2,0),(2,6)), ((3,0),(3,5)), ((4,0),(4,4)),((5,0),(5,3)),
        ((2,0),(-1,3)),((3,0),(-1,4)), ((4,0),(-1,5)), ((5,0),(-1,6)), ((5,1),(0,6)), ((5,2),(1,6)),((5,3),(2,6))
    ]
    var stageLines:[TriLine] = []
    //ステージの背景の六角形
    let backGroundHexagon:[TriVertexCoordinate] = [
        TriVertexCoordinate(x: 2, y: 0), TriVertexCoordinate(x: 5, y: 0),
        TriVertexCoordinate(x: 5, y: 3),TriVertexCoordinate(x: 2, y: 6),
        TriVertexCoordinate(x: -1, y: 6),TriVertexCoordinate(x: -1, y: 3),
        TriVertexCoordinate(x: 2, y: 0)
    ]
    
    //ステージの生成時の確率をまとめたクラス
    private var probabilityOfLayout = ProbabilityOfStageLayout()
    
    //Triangleを消した数のカウント、クリアチェックに利用
    private var deleteTriangleCounter:Int = 0
    
    init(){
        //初期化時にステージの構造を生成
        setStageTriangles()
        setStageLines()
        setStageActionItems()
        deleteTriangleCounter = 0
    }
    
    deinit{
        triangles = []
        actionItems = []
        selectedActionItem = nil
    }
   
    //ステージの構造生成
    ///三角形のビューのセットアップ
    private func setStageTriangles(){
        for (triangleY, arrangement) in triangleArrengement.enumerated(){
            for triangleX in arrangement{
                
                let random:Double = Double.random(in:1...100)
                if random <= probabilityOfLayout.ofTriangles{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOn, action: nil )
                    triangles.append(triangleModel)
                }else{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOff, action: nil )
                    triangles.append(triangleModel)
                }
            }
        }
    }
    ///線を引くビューのセットアップ
    private func setStageLines(){
        let lines = lineArrangement.map{
            TriLine(start: TriVertexCoordinate(x: $0.start.x, y: $0.start.y),
                    end: TriVertexCoordinate(x: $0.end.x, y: $0.end.y))
        }
        stageLines.append(contentsOf: lines)
    }
    
    ///ステージにItemの描画をセットする
    private func setStageActionItems(){
        //TODO: 前のステージで持っていたアイテムを引き継ぐ
        actionItems.append(contentsOf: [ActionItemModel(action: .triforce)])
        actionItems.append(contentsOf: [ActionItemModel(action: .triforce)])
    }
    
   
   
    ///タップアクションを受けて、ビューを更新する
    ///順番に描画が更新されるように時間をずらしながら実行
    func updateTrianglesStatusAndItem(action: TriangleTapAction) {
      
        //アクションを行う場所に対して操作できないようにステータスを変更する
        for plan in action.plans {
            switch plan.changeStatus{
            case .toTurnOn:
                self.triangles[plan.index].status = .onAppear
            case .toTurnOff:
                self.triangles[plan.index].status = .isDisappearing
            case .toTurnOffWithAction:
                self.triangles[plan.index].status = .isDisappearing
            }
        }
        
        let dispachGroup = DispatchGroup()
        
        for plan in action.plans {
            
            let countTime = 0.3 * Double(plan.count)
            
            dispachGroup.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + countTime){
                switch plan.changeStatus{
                case .toTurnOn:
                    self.triangles[plan.index].status = .isOn
                case .toTurnOff:
                    self.triangles[plan.index].status = .isOff
                case .toTurnOffWithAction:
                    self.triangles[plan.index].status = .isOff
                    self.triangles[plan.index].action = nil
                }
                dispachGroup.leave()
            }
        }
        
        //全て終わったらアイテムを追加する
        //TODO: スコアの計算とステージのクリア判定
        dispachGroup.notify(queue: .main){
            
            if let additionalItem = action.additionalItem{
                self.actionItems.append(additionalItem)
              
            }
        }
    }
}

enum StageError:Error{
    case isNotExist
    case triangleIndexError
}
