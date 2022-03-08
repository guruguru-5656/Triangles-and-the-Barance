//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


final class StageModel:ObservableObject,TriCoodinatable{
    @Published var triangles: [TriangleModel]
    @Published var currentColor = MyColor.lightRed
    //後々イニシャライザはステージ生成時にインスタンスを作成するように変更予定
    //シングルトンの実装
    //    static var shared = StageModel()
    //    private
    init(){
        //初期化時にステージの構造から
        self.triangles = Self.createTriangleModel(stageArrangement)
    }
    
    //ステージの構造
    var stageArrangement: [TriCoordinate] = [
        (2, 0, true),(3, 0, true),(4, 0, true),
        (1, 1, true),(2, 1, true),(3, 1, true),(4, 1, true),
        (0, 2, true),(1, 2, true),(2, 2, true),(3, 2, true),(4, 2, true),
        (-1, 3, true),(0, 3, true),(1, 3, true),(2, 3, true),(3, 3, true),(4, 3, true),
        (-1, 4, true),(0, 4, true),(1, 4, true),(2, 4, true),(3, 4, true),
        (-1, 5, true),(0, 5, true),(1, 5, true),(2, 5, true),
        
        (2, 0, false),(3, 0, false),(4, 0, false),(5, 0, false),
        (1, 1, false),(2, 1, false),(3, 1, false),(4, 1, false),(5, 1, false),
        (0, 2, false),(1, 2, false),(2, 2, false),(3, 2, false),(4, 2, false),(5, 2, false),
        (0, 3, false),(1, 3, false),(2, 3, false),(3, 3, false),(4, 3, false),
        (0, 4, false),(1, 4, false),(2, 4, false),(3, 4, false),
        (0, 5, false),(1, 5, false),(2, 5, false)
    ]
    func copyOfTriangles() -> [TriangleModel]{
        self.triangles
    }
    //座標の配列からインスタンスを生成するメソッド
    static func createTriangleModel(_ coordinate:[TriCoordinate]) -> [TriangleModel]{
        var instance:[TriangleModel] = []
        for coordinate in coordinate{
            let randomNumber = Int.random(in: 1...100)
            if randomNumber > 50{
                instance.append(TriangleModel(triCoordinate: coordinate ,isOn: true))
            }else{
                instance.append(TriangleModel(triCoordinate: coordinate ,isOn: false))
            }
        }
        return instance
    }
    ///座標を受け取り(ステージの配列のindex、処理する順番)の配列を返す
    func tapped(_ coordinate: TriCoordinate) -> [(Int, Int)]{
        //2重に探索しないように現在のステージの情報のコピーを取得する
        var triangles = triangles.map{$0}
        var searchingValues:[(Int, Int)] = []
        var returnValue:[(Int, Int)] = []
        var count = 0
        //ステージの中からタップされた座標のindexを取得
        guard let index = getIndexOfStage(coordinate)
        else{
            print("\(coordinate) is out of stage")
            return returnValue
        }
        searchingValues.append((index, count))
        
        while let firstValue = searchingValues.first{
            //serchingValuesの中に現在処理している番号と同じものがあるかどうか確認。
            //なかったらcountを一つ増やす
            if !searchingValues.map({ $0.1 }).contains(count){
                count += 1
            }
            //
            if triangles[firstValue.0].isOn == true{
            //隣接するマスを探索予定に追加
                getNextIndex(firstValue.0).forEach{
                    searchingValues.append(($0, count+1))
                }
                //今探索している座標をfalseにする
                triangles[firstValue.0].isOn = false
                returnValue.append((firstValue.0, count))
            }
            searchingValues.removeFirst()
        }
        return returnValue
    }
    func getIndexesToBeErased(index:[Int]) -> [Int]{
        var returnValue:[Int] = []
        //隣接する座標でOnになっている配列を取得
        var serchingIndex = index
        if index.isEmpty{
            return []
        }else{
            let next = getNextIndex(index[0]).filter{triangles[$0].isOn == true}
            serchingIndex.append(contentsOf: next)
            serchingIndex.removeFirst()
            getIndex
        }
        return returnValue
    }
    
    ///入力されたindexからステージ内を検索し、その隣接する座標のindexを返す
    func getNextIndex(_ index:Int) -> [Int]{
        let nextcoordinate = next(triangles[index].triCoordinate)
        var nextIndex:[Int] = []
        nextcoordinate.forEach{
            if let index = getIndexOfStage($0){
                nextIndex.append(index)
            }
        }
        return nextIndex
    }
    
    ///入力された座標からステージ内を検索し、そのindexを返す
    func getIndexOfStage(_ coordinate: TriCoordinate) -> Int?{
        triangles.firstIndex(where:{$0.triCoordinate == coordinate})
    }
    ///プロトコル準拠のため実装するも今の所使い道なし
    var triCoordinates: TriCoordinate = (0,0,true)
    //インスタンスを生成するとデフォルト値がMyColorにセットされる
    //nextメソッドを実行すると、次のカラーを取得し、現在のカラーを更新する
    
    func nextColor(){
        var nextColor:MyColor
        switch currentColor{
        case .lightPink:
            nextColor = MyColor.lightRed
        default:
            nextColor = MyColor.init(rawValue: currentColor.rawValue+1)!
        }
        currentColor = nextColor
    }
    
    enum MyColor:Int{
        case lightRed = 0
        case lightOrenge,lightYellow,lightYellowGreen,lightGreen,lightGreenBlue,
             lightWaterBlue,lightWhiteBlue,lightBluePurple,lightPurple,lightFujiPurple,
             lightPinkPurple,lightPink
        
        var color:Color{
            switch self{
            case .lightRed:
                return Color.lightRed
            case .lightOrenge:
                return Color.lightOrenge
            case .lightYellow:
                return Color.lightYellow
            case .lightYellowGreen:
                return Color.lightYellowGreen
            case .lightGreen:
                return Color.lightGreen
            case .lightGreenBlue:
                return Color.lightGreenBlue
            case .lightWaterBlue:
                return Color.lightWaterBlue
            case .lightWhiteBlue:
                return Color.lightWhiteBlue
            case .lightBluePurple:
                return Color.lightBluePurple
            case .lightPurple:
                return Color.lightPurple
            case .lightFujiPurple:
                return Color.lightFujiPurple
            case .lightPinkPurple:
                return Color.lightPinkPurple
            case .lightPink:
                return Color.lightPink
            }
        }
    }
}

