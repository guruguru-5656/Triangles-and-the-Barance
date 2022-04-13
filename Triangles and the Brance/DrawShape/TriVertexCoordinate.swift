//
//  File.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import Foundation
import SwiftUI
///x、yが描画の頂点の座標を表す座標系
struct TriVertexCoordinate:Hashable{
    let vertexX:Int
    let vertexY:Int
    
    init(x:Int,y:Int){
        vertexX = x
        vertexY = y
    }

    var drawPoint:CGPoint{
        let X = Double(vertexX)
        let Y = Double(vertexY)
        return CGPoint(x: X + Y/2-1/2, y: Y * sqrt(3)/2-1/(2*sqrt(3)) )
    }
}
    
struct TriLine:Hashable,Identifiable{
    let start:TriVertexCoordinate
    let end:TriVertexCoordinate
    var id = UUID()
}
