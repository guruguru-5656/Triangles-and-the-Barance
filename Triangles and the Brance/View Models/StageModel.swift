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
    @Published var deleteTriangleCounter = 0
    @Published var actionItems:[ActionItemModel] = []
    @Published var selectedItem:ActionItemModel?
    
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
    
    init(){
        //初期化時にステージの構造を生成
        setStageTriangles()
        setStageLines()
        setStageActionItems()
        deleteTriangleCounter = 0
    }
    
    //ステージの構造生成
    ///三角形のビューのセットアップ
    func setStageTriangles(){
        for (triangleY, arrangement) in triangleArrengement.enumerated(){
            for triangleX in arrangement{
                let random:Double = Double.random(in:1...100)
                if random <= probabilityOfLayout.ofTriangles{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOn )
                    triangles.append(triangleModel)
                }else{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOff )
                    triangles.append(triangleModel)
                }
            }
        }
    }
    ///線を引くビューのセットアップ
    func setStageLines(){
         let lines = lineArrangement.map{
            TriLine(start: TriVertexCoordinate(x: $0.start.x, y: $0.start.y),
                    end: TriVertexCoordinate(x: $0.end.x, y: $0.end.y))
        }
        stageLines.append(contentsOf: lines)
    }
    
    func setStageActionItems(){
        actionItems.append(contentsOf: [ActionItemModel(type: .triforce)])
    }
  
    //ステージを書き換えるアクション
    //Triangleのアクション
    ///実際にTriangleを消去する操作を行う
   private func deleteTrianglesAction(index:Int,count:Int,action:ActionType) {
        switch action{
        case .normal:
            DispatchQueue.main.async {
                self.triangles[index].status = .isDisappearing
            }
            let timeCount = DispatchTime.now() + DispatchTimeInterval.milliseconds( count * 300)
            DispatchQueue.main.asyncAfter(deadline: timeCount){ [weak self] in
                self?.triangles[index].status = .isOff
                self?.deleteTriangleCounter += 1
            }
        case .triforce:
            return
        }
   }
    
    ///Triangleの消去の順番を求めて、deleteTriangleActionを呼び出す
   private func deleteTriangles(coordinate:ModelCoordinate,action:ActionType){
   //Offにする予定の座標を設定、一定時間後に消去を行うためにカウンターを用意
        var willSearch:Set<ModelCoordinate> = []
        var counter = 0
        var didSearched:Set<ModelCoordinate> = []
        
        
        willSearch.insert(coordinate)
        while !willSearch.isEmpty{
            let searching = willSearch
            for searchingNow in searching {
                didSearched.insert(searchingNow)
                //ステージの範囲外かチェック
                if !triangles.contains(where: { $0.coordinate == searchingNow}) {
                    continue
                }
                //インデックスの取得チェック
                guard let index = getIndexOfStageTriangles(coordinate: searchingNow)
                else{
                    print("ステージ内のインデックスエラー")
                    continue
                }
                //Onだった場合は次探索する予定の配列に加える
                if triangles[index].status == .isOn{
                    deleteTrianglesAction(index: index, count: counter, action: action)
                    let nextSet = getNextCoordinates(coordinate: searchingNow)
                    willSearch.formUnion(nextSet)
                }
 
                willSearch.subtract(didSearched)
   
            }
            
            counter += 1
        }
    }
    
    ///Triangleのステータスを参照し、アクションを実行するか判断する
    ///statusがisOnだった場合はdeleteTrianglesを呼び出す
    func deleteTrianglesInput(index:Int){
        if triangles[index].status == .isOn{
            let coordinate = triangles[index].coordinate
            DispatchQueue.global().async{ [weak self] in
                self?.deleteTriangles(coordinate: coordinate,action:.normal)
            }
        }
        if triangles[index].status == .isOff{
            triangles[index].status = .isOn
            print(triangles[index].status)
        }
    }
    
    ///Triangleの座標で検索を行い、ステージ配列のインデックスを取得する
    func getIndexOfStageTriangles(coordinate:ModelCoordinate) -> Int?{
        triangles.firstIndex{ $0.coordinate == coordinate }
    }
    ///ステージ内の隣接した座標を取得する
    func getNextCoordinates(coordinate:ModelCoordinate) -> Set<ModelCoordinate>{
        //隣接する座標を取得する
        var nextCoordinates:[ModelCoordinate] = []
        let remainder = coordinate.x % 2
        if remainder == 0{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y-1),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y),])
        }else{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y+1),])
        }
        var nextInStage:Set<ModelCoordinate> = []
        for nextCoordinate in nextCoordinates {
            if triangles.map({$0.coordinate})
                .contains(where: {$0 == nextCoordinate}) == true{
                nextInStage.insert(nextCoordinate)
            }
        }
        
        return nextInStage
    }
    
}

