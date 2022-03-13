//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


final class StageModel:ObservableObject,TriangleViewModelDelegate{
    
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
        var willSearch:Set<ModelCoordinate> = [coordinate]
        var counter = 0
        var didSearched:Set<ModelCoordinate> = []
        //Offにする予定の座標が残っている間は繰り返す
        while !willSearch.isEmpty{
            //次に処理する予定の座標を格納（for文の中でwillSearchCoordinatesが更新できないため別の変数を用意）
            let searchingCoordinates = willSearch
            
            for searching in searchingCoordinates{

                //現在探索座標の処理に入ったため、探索終了に加える
                didSearched.insert(searching)
                willSearch.remove(searching)

                print(willSearch.count)
                print(didSearched.count)
                
                //隣接座標を取得し、Onだったら探索予定に加え、Offだったら探索済みに加える
                let nextCoordinates = getNextCoordinates(coordinate: searching)
//                nextCoordinates.subtract(didSearched)
                for nextCoordinate in nextCoordinates{
                    if didSearched.contains(where:{$0 == nextCoordinate}){
                        continue
                    }
                    let index = getIndexOfStageTriangles(coordinate: nextCoordinate)
                    if let index = index{
                        if stageTriangles[index].isOn{
                            willSearch.insert(nextCoordinate)
                        }else{
                            didSearched.insert(nextCoordinate)
                        }
                    }
                }
            
                //探索予定から探索済みを取り除く
                willSearch.subtract(didSearched)       
                print(willSearch.count)
                print(didSearched.count)
                //今処理している座標のIndexを取得し、それをdeleteTriangleActionに渡す
                    let searchingIndex = getIndexOfStageTriangles(coordinate:searching)
           
                if let index = searchingIndex {
                    deleteTrianglesAction(index: index, count: counter, action: action)
                }else{
                    print("index\(String(describing: searchingIndex))はステージの範囲外")
                }
               
            }
            
            //カウンターを更新する
            counter += 1
           print(counter)
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
                ModelCoordinate(x:coordinate.x, y:coordinate.y-1),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y),])
        }else{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x, y:coordinate.y+1),])
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
