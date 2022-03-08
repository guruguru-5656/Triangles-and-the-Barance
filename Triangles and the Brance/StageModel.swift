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
    
    func tapped(_ triangle: TriangleModel){
        //タップされた座標がonかどうか確認しonだった場合はoffにする
        //offだった場合は何もせずに終了
        guard triangle.isOn else{ return }
        //ステージの中からタップされた座標のindexを取得し、stageデータの書き換えを行う
        guard let index = getIndexOfStage(triangle.triCoordinate)
        else{ return }
        triangles[index].isOn = false
        print("first\(index)")
        //ステージの配列から、隣接していている座標のindexを取得
      
        let nextIndexes = next(triangle.triCoordinate).map{getIndexOfStage($0)}
        //nilのデータを弾いて空配列の場合は終了
       
        let nextIndex = nextIndexes.filter{ $0 != nil }
        print("next\(nextIndex)")
        
        guard !nextIndex.isEmpty else { return }
        
        //隣接する座標の中でまたtappedメソッドを実行する
        for nextIndex in nextIndex{
            tapped(triangles[nextIndex!])
        }
    }
    //入力された座標からステージ内を検索し、そのindexを返す
    func getIndexOfStage(_ coordinate: TriCoordinate) -> Int?{
        triangles.firstIndex(where:{$0.triCoordinate == coordinate})
    }
    //プロトコル準拠のため実装するも今の所使い道なし
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

