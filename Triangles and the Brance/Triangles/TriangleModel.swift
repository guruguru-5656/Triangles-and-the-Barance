//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI


///Triangleのモデルデータ
struct TriangleViewModel:Identifiable{
    init(x: Int,y: Int, status: ViewStatus, action: ActionItem?) {
        coordinate = ModelCoordinate(x: x, y: y)
        self.status = status
        self.actionItem = action
    }
    var coordinate: ModelCoordinate
    var status: ViewStatus
    var actionItem: ActionItem?
    
    var reversed: Bool {
        let remainder = coordinate.x % 2
        if remainder == 0 {
            return true
        } else {
            return false
        }
    }
     let id = UUID()
    ///対応する頂点の座標系
    var vertexCoordinate: [TriVertexCoordinate] {
        let returnCoordinates: [TriVertexCoordinate]

        if reversed {
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
        if remainder == 0 {
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
enum ViewStatus {
    case onAppear
    case isOn
    case isDisappearing
    case isOff
}
///座標、中心部分を使ってステージの中の位置を表す
struct ModelCoordinate:Hashable{
    var x: Int
    var y: Int
    ///隣接する座標のSet
    var nextCoordinates: Set<ModelCoordinate> {
       let nextCoordinates: Set<ModelCoordinate>
       let remainder = self.x % 2
        if remainder == 0 {
            nextCoordinates = ([
               ModelCoordinate(x: self.x-1, y: self.y),
               ModelCoordinate(x: self.x+1, y: self.y-1),
               ModelCoordinate(x: self.x+1, y: self.y),])
        }else{
            nextCoordinates = ([
               ModelCoordinate(x: self.x-1, y: self.y),
               ModelCoordinate(x: self.x+1, y: self.y),
               ModelCoordinate(x: self.x-1, y: self.y+1),])
        }
        return nextCoordinates
    }
    ///三角形の向き
    var reversed: Bool {
        let remainder = x % 2
        if remainder == 0 {
            return true
        } else {
            return false
        }
    }
    
    //相対座標を指定する配列から現在の座標をもとにした座標の配列を返す
    func relative(coordinates: [[(x: Int, y: Int)]]) -> [[ModelCoordinate]] {
        coordinates.map { coor in
            coor.map {
                if reversed {
                  return  ModelCoordinate(x: self.x + $0.x, y: self.y + $0.y)
                } else {
                  return  ModelCoordinate(x: self.x - $0.x, y: self.y - $0.y)
                }
            }
        }
    }
}

