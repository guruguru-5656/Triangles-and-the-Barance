//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class StageModel:ObservableObject,TriangleViewModelDelegate{
    
    @Published var stageTriangles: [TriangleViewModel] = []
    @Published var currentColor = MyColor()
    @Published var deleteTriangleCounter = 0
    ///外側の配列がY軸、内側の配列がX軸を表す
    private var arrangementOfTriangle: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    private let stageLineArrangement:[(start:(x:Int,y:Int),end:(x:Int,y:Int))] = [
        ((1,1),(5,1)), ((0,2),(5,2)), ((-1,3),(5,3)), ((-1,4),(4,4)), ((-1,5),(3,5)),
        ((0,2),(0,6)), ((1,1),(1,6)), ((2,0),(2,6)), ((3,0),(3,5)), ((4,0),(4,4)),
        ((3,0),(-1,4)), ((4,0),(-1,5)), ((5,0),(-1,6)), ((5,1),(0,6)), ((5,2),(1,6))
    ]
    var stageLines:[TriLine] = []
    
    
    
    init(){
        //初期化時にステージの構造を生成
        setStageTriangles()
        setStageLines()
        deleteTriangleCounter = 0
    }
   
    //ステージの構造生成
    func setStageTriangles(){
        for (triangleY, arrangement) in arrangementOfTriangle.enumerated(){
            for triangleX in arrangement{
                var triangleModel = TriangleViewModel(x: triangleX, y: triangleY, isOn: true )
                triangleModel.delegate = self
                stageTriangles.append(triangleModel)
            }
        }
    }
    func setStageLines(){
         let lines = stageLineArrangement.map{
            TriLine(start: TriVertexCoordinate(x: $0.start.x, y: $0.start.y),
                    end: TriVertexCoordinate(x: $0.end.x, y: $0.end.y))
        }
        stageLines.append(contentsOf: lines)
    }
    
    func deleteTrianglesAction(index:Int,count:Int,action:ActionOfShape) {
        switch action{
        case .normal:
            let timeCount = DispatchTime.now() + DispatchTimeInterval.milliseconds( count * 300)
            DispatchQueue.main.asyncAfter(deadline: timeCount){ [weak self] in
                self?.stageTriangles[index].isOn = false
                self?.deleteTriangleCounter += 1
            }
        }
    }
    
    
    
    func deleteTriangles(coordinate:ModelCoordinate,action:ActionOfShape){
   //Offにする予定の座標を設定、一定時間後に消去を行うためにカウンターを用意
        var willSearch:Set<ModelCoordinate> = []
        var counter = 0
        var didSearched:Set<ModelCoordinate> = []
        
        
        willSearch.insert(coordinate)
        while !willSearch.isEmpty{
            let searching = willSearch
            for searchingNow in searching {
                didSearched.insert(searchingNow)
                if !stageTriangles.contains(where: { $0.modelCoordinate == searchingNow}) {
                   
                    continue
                }
                
                guard let index = getIndexOfStageTriangles(coordinate: searchingNow)
                else{
                    print("ステージ内のインデックスエラー")
                    continue
                }
                if stageTriangles[index].isOn{
                    deleteTrianglesAction(index: index, count: counter, action: action)
                    let nextSet:Set<ModelCoordinate> = getNextCoordinates(coordinate: searchingNow)
                    willSearch.formUnion(nextSet)
                }
 
                willSearch.subtract(didSearched)
   
            }
            
            counter += 1
        }
    }
    
    func getIndexOfStageTriangles(coordinate:ModelCoordinate) -> Int?{
        stageTriangles.firstIndex{ $0.modelCoordinate == coordinate }
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
            if stageTriangles.map({$0.modelCoordinate})
                .contains(where: {$0 == nextCoordinate}) == true{
                nextInStage.insert(nextCoordinate)
            }
        }
//
        return nextInStage
    }
}

final class DeleteTriangles:StageModel{
    var willSearch:Set<ModelCoordinate> = []
    var counter = 0
    var didSearched:Set<ModelCoordinate> = []
    func makeScheduleForDelete(coordinate:ModelCoordinate){
        willSearch.insert(coordinate)
        while !willSearch.isEmpty{
            let searching = willSearch
            for searching in searching {
                if let index = getIndexOfStageTriangles(coordinate: searching){
                    if stageTriangles[index].isOn{
                        
                    }
                    
                }
            }
        }
    }
}


//    ///ステージの書き換えを行う
//    func delete(coordinate:TriCoordinate){
//        guard let scheduledForDelete:[(index:Int,count:Int)] = getscheduledForDelete(coordinate) else{
//            print("範囲外エラー")
//            return
//        }
//        guard !scheduledForDelete.isEmpty else{return}
//
//        for schedule in scheduledForDelete {
//            let timeCount = DispatchTime.now() + DispatchTimeInterval.milliseconds( schedule.count * 300 )
//            DispatchQueue.main.asyncAfter(deadline: timeCount){ [self] in
//                stageTriangles[schedule.index].isOn = false
//        }
//        }
//    }
//    ///座標を受け取り(ステージの配列のindex、処理する順番)の配列を返す
//    func getscheduledForDelete(_ coordinate: TriCoordinate) -> [(index:Int,count:Int)]?{
//        //取得した座標がステージの範囲外だった場合はエラーを返す
//        guard let index = getIndexOfStage(coordinate) else{return nil}
//        //判定開始の座標がOn出なかった場合は空配列を返す
//        guard stageTriangles[index].isOn == true else{return []}
//        //検索予定の配列を定義、判定開始地点の座標を探索予定の座標にセット
//        var indexesWillSearch:[Int] = [index]
//        //判定済みの座標、探索中の座標、カウンターを作成
//        var indexesAreTurnedOff:[(index:Int,count:Int)] = []
//        var searchingIndexes:[Int] = []
//        var counter = 0
//
//        while !indexesWillSearch.isEmpty{
//            //探索予定の座標を探索中の座標にセット
//            searchingIndexes = indexesWillSearch
//            for searching in searchingIndexes{
//                //隣接する座標からOnになっている座標を取得
//                var nextIndexIsOn = getNextIndex(searching).filter{ index in
//                    stageTriangles[index].isOn  == true }
//                //隣接座標の中から既に判定済みの座標を取り除いた配列を作成
//                removeFromArray(from: &nextIndexIsOn, at: indexesAreTurnedOff.map{$0.index})
//                //配列の更新を行う
//                indexesWillSearch.append(contentsOf: nextIndexIsOn)
//                indexesAreTurnedOff.append((index:searching,count:counter))
//                indexesWillSearch.remove(at: indexesWillSearch.firstIndex(of: searching)!)
//            }
//            counter += 1
//        }
//
//        print(indexesAreTurnedOff)
//
//        return indexesAreTurnedOff
//    }
//
