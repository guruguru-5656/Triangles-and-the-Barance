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
    var action:ActionType = .normal
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
    
    static func getMidleOfVertexPoints(coordinate:ModelCoordinate) -> [CGPoint]{
        let returnPoints:[CGPoint]
        let X = Double(coordinate.x)
        let Y = Double(coordinate.y)
        
        let remainder = coordinate.x % 2
        if remainder == 0{
            returnPoints = [
                CGPoint(x:(1 + X + Y)/2,
                        y:Y*sqrt(3)/2),
                CGPoint(x: (1 + X*2 + Y*2)/4,
                        y: (Y + 1/2) * sqrt(3)/2),
                CGPoint(x: (3 + X*2 + Y*2)/4,
                        y: (Y + 1/2) * sqrt(3)/2)
            ]
        }else{
            returnPoints = [
                CGPoint(x:CGFloat( 1+coordinate.x+coordinate.y )/2,y:CGFloat(coordinate.y+coordinate.y*2)*sqrt(3)/2),
            
            ]
        }
        return returnPoints
    }
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

