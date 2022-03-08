//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

//class TriangleAction:ObservableObject,TriCoodinatable{
//    var triangles: [TriangleModel] = []
//    @Published var stage = StageModel.shared
//
//
//}

struct TriangleModel:Identifiable{
    typealias TriCoordinate = (Int,Int,Bool)
    var triCoordinate: TriCoordinate
    var isOn:Bool
    var id = UUID()
}

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
    ///座標からModelデータを生成するメソッド
    func createTriangleModel(_ coordinate:TriCoordinate) -> TriangleModel{
        TriangleModel(triCoordinate: coordinate ,isOn: true)
    }
}
