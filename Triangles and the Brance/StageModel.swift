//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


final class StageModel:ObservableObject{
    @Published var stageTriangles: [TriangleModel] = []
    @Published var currentColor = MyColor()
  
    ///外側の配列がY軸、内側の配列がX軸を表す
    private var arrangementOfTriangle: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    
    init(){
        //初期化時にステージの構造から
        setStageTriangles()
    }
    
    //ステージの構造
    func setStageTriangles(){
        for (triangleY, arrangement) in arrangementOfTriangle.enumerated(){
            for triangleX in arrangement{
                stageTriangles.append(
                    TriangleModel(x: triangleX, y: triangleY, isOn: true ))
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
//    ///ステージの中にある隣接した座標のindex
//    func nextIndexIsOn(index:Int) -> [Int]{
//        getNextIndex(index).filter{stageTriangles[$0].isOn == true}
//    }
//    ///第一引数の配列から第二因数に含まれている要素を取り除く
//    func removeFromArray(from originalArray:inout [Int],at array:[Int]){
//        for content in array{
//            if let filterArray = originalArray.firstIndex(of: content){
//                originalArray.remove(at: filterArray)
//            }
//        }
//    }
    
//    ///入力されたindexからステージ内を検索し、その隣接する座標のindexを返す
//    func getNextIndex(_ index:Int) -> [Int]{
//        let nextcoordinate = next(stageTriangles[index].triCoordinate)
//        var nextIndex:[Int] = []
//        nextcoordinate.forEach{
//            if let index = getIndexOfStage($0){
//                nextIndex.append(index)
//            }
//        }
//        print(nextIndex)
//        return nextIndex
//    }
//
//    ///入力された座標からステージ内を検索し、そのindexを返す
//    func getIndexOfStage(_ coordinate: TriCoordinate) -> Int?{
//        stageTriangles.firstIndex(where:{$0.triCoordinate == coordinate})
//    }
    
    


