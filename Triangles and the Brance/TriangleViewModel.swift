//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

///トライアングルViewのモデルデータ
struct TriangleViewModel:Identifiable{
    
    init(x:Int,y:Int,status:TriangleStatus){
        modelCoordinate = ModelCoordinate(x: x, y: y)
        self.status = status
        
    }
    
    ///当たり判定、Viewの読み込み時に設定され、ドラッグ&ドロップのドロップ時の判定に使用される
    var hitBox:CGRect?
    
    var modelCoordinate:ModelCoordinate
    var status:TriangleStatus
    var action:ActionOfShape = .normal
    var id = UUID()
    ///隣接するTriangleのModelCoordinateの座標を取得
    var nextModelCoordinates:[ModelCoordinate]{
        var nextCoordinates:[ModelCoordinate] = []
        let remainder = modelCoordinate.x % 2
        if remainder == 0{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:modelCoordinate.x-1, y:modelCoordinate.y),
                ModelCoordinate(x:modelCoordinate.x+1, y:modelCoordinate.y-1),
                ModelCoordinate(x:modelCoordinate.x+1, y:modelCoordinate.y),])
        }else{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:modelCoordinate.x-1, y:modelCoordinate.y),
                ModelCoordinate(x:modelCoordinate.x+1, y:modelCoordinate.y),
                ModelCoordinate(x:modelCoordinate.x-1, y:modelCoordinate.y+1),])
        }
        return nextCoordinates
    }
    
    ///対応する頂点の座標系
    var vertexCoordinate:[TriVertexCoordinate]{
        let returnCoordinates:[TriVertexCoordinate]

        let remainder = modelCoordinate.x % 2
        if remainder == 0{
            returnCoordinates = [TriVertexCoordinate(x:modelCoordinate.x/2, y:modelCoordinate.y),
                          TriVertexCoordinate(x:modelCoordinate.x/2 + 1, y:modelCoordinate.y),
                          TriVertexCoordinate(x:modelCoordinate.x/2, y:modelCoordinate.y + 1)]
        }else{
            returnCoordinates = [TriVertexCoordinate(x:(modelCoordinate.x+1)/2, y:modelCoordinate.y),
                          TriVertexCoordinate(x:(modelCoordinate.x+1)/2 - 1, y:modelCoordinate.y + 1),
                          TriVertexCoordinate(x:(modelCoordinate.x+1)/2, y:modelCoordinate.y + 1)]
        }
        return returnCoordinates
    }
    ///頂点の座標を取得するメソッドバージョン
    static func getVertexCoordinate(x:Int,y:Int) -> [TriVertexCoordinate]{
        let coordinates:[TriVertexCoordinate]

        let remainder = x % 2
        if remainder == 0{
            coordinates = [TriVertexCoordinate(x:x/2, y:y),
                          TriVertexCoordinate(x:x/2 + 1, y:y),
                          TriVertexCoordinate(x:x/2, y:y + 1)]
        }else{
            coordinates = [TriVertexCoordinate(x:(x+1)/2, y:y),
                          TriVertexCoordinate(x:(x+1)/2 - 1, y:y + 1),
                          TriVertexCoordinate(x:(x+1)/2, y:y + 1)]
        }
        return coordinates
    }
}


enum ActionOfShape{
    case normal
}

enum TriangleStatus{
    case isOn
    case isDisappearing
    case isOff
}
///座標、中心部分を使ってステージの中の位置を表す
struct ModelCoordinate:Hashable{
    var x:Int
    var y:Int
}

