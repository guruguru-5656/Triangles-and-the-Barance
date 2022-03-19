//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

///Triangleのモデルデータ
 struct TriangleViewModel:Identifiable{
    
     init(x:Int,y:Int, status:TriangleStatus, action:ActionType?){
        coordinate = ModelCoordinate(x: x, y: y)
        self.status = status
         self.action = action
    }
     var coordinate:ModelCoordinate
     var status:TriangleStatus
     var action:ActionType?
     
     private weak var stage:StageModel?
     var index:Int{
         (stage?.triangles.firstIndex{ $0.id == self.id })!
     }
     var id = UUID()
     ///隣接するTriangleのModelCoordinateの座標を取得
     var nextModelCoordinates:[ModelCoordinate]{
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
        return nextCoordinates
    }
    
    ///対応する頂点の座標系
    var vertexCoordinate:[TriVertexCoordinate]{
        let returnCoordinates:[TriVertexCoordinate]

        let remainder = coordinate.x % 2
        if remainder == 0{
            returnCoordinates = [TriVertexCoordinate(x:coordinate.x/2, y:coordinate.y),
                          TriVertexCoordinate(x:coordinate.x/2 + 1, y:coordinate.y),
                          TriVertexCoordinate(x:coordinate.x/2, y:coordinate.y + 1)]
        }else{
            returnCoordinates = [TriVertexCoordinate(x:(coordinate.x+1)/2, y:coordinate.y),
                          TriVertexCoordinate(x:(coordinate.x+1)/2 - 1, y:coordinate.y + 1),
                          TriVertexCoordinate(x:(coordinate.x+1)/2, y:coordinate.y + 1)]
        }
        return returnCoordinates
    }
    ///頂点の座標を取得するメソッド
    static func getVertexCoordinate(coordinate:ModelCoordinate) -> [TriVertexCoordinate]{
        let returnCoordinates:[TriVertexCoordinate]

        let remainder = coordinate.x % 2
        if remainder == 0{
            returnCoordinates = [TriVertexCoordinate(x:coordinate.x/2, y:coordinate.y),
                                 TriVertexCoordinate(x:coordinate.x/2 + 1, y:coordinate.y),
                          TriVertexCoordinate(x:coordinate.x/2, y:coordinate.y + 1)]
        }else{
            returnCoordinates = [TriVertexCoordinate(x:(coordinate.x+1)/2, y:coordinate.y),
                          TriVertexCoordinate(x:(coordinate.x+1)/2 - 1, y:coordinate.y + 1),
                          TriVertexCoordinate(x:(coordinate.x+1)/2, y:coordinate.y + 1)]
        }
        return returnCoordinates
    }
    
    
}

///現在の状態を表す、これにより入力の受付の判断や、描画の状態を変更する
enum TriangleStatus{
    case onAppear
    case isOn
    case isDisappearing
    case isOff
}
///座標、中心部分を使ってステージの中の位置を表す
struct ModelCoordinate:Hashable{
    var x:Int
    var y:Int
}

