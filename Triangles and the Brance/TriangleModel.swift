//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI





protocol TriCoodinatable{
    //Triangleの座標を扱うプロトコル
    typealias TriCoordinate = (Int,Int,Bool)
    func next(_ coordinate:TriCoordinate) -> [TriCoordinate]
    func createTriangleModel(_ coordinate:TriCoordinate) -> TriangleModel
}

extension TriCoodinatable{
    ///隣接するマスを取得するメソッド
    func next(_ coordinate:TriCoordinate) -> [TriCoordinate]{
        switch coordinate.2{
        case true:
            return [(coordinate.0 + 1, coordinate.1 - 1, false),
                    (coordinate.0 + 1, coordinate.1, false),
                    (coordinate.0 , coordinate.1, false)]
        case false:
            return [(coordinate.0 - 1, coordinate.1, true),
                    (coordinate.0, coordinate.1, true),
                    (coordinate.0 - 1, coordinate.1 + 1, true)]
        }
    }

}

///モデルデータの座標、中心部分を使ってステージの中の位置を表す
struct TriangleModel:Identifiable{
    
    init(x:Int,y:Int,isOn:Bool){
        self.modelCoordinates = (x:x,y:y)
        self.isOn = isOn
    }
    var isOn:Bool
    var modelCoordinates:(x:Int,y:Int)
    
    
    var id = UUID()
}
