//
//  File.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import Foundation
import SwiftUI
///x、yが描画の頂点の座標を表す座標系
struct TriangleVertexCoordinate:Hashable, StageCoordinate{
    let x:Int
    let y:Int
    let position: Position = .vertex
    
    init(x:Int,y:Int){
        self.x = x
        self.y = y
    }

    var drawPoint:CGPoint{
        let X = Double(x)
        let Y = Double(y)
        return CGPoint(x: X + Y/2 - 1/2, y: Y * sqrt(3)/2 )
    }
    //相対座標を指定する配列から現在の座標をもとにした座標の配列を返す
    func relative(coordinates: [[(x: Int, y: Int)]]) -> [[TriangleCenterCoordinate]] {
        return coordinates.map { coor in
            coor.map {
                return  TriangleCenterCoordinate(x: self.x * 2 + $0.x, y: self.y + $0.y)
            }
        }
    }
}
    
protocol StageCoordinate {
    var x: Int { get }
    var y: Int { get }
    var drawPoint: CGPoint { get }
    func relative(coordinates: [[(x: Int, y: Int)]]) -> [[TriangleCenterCoordinate]]
    var position:Position { get }
}
