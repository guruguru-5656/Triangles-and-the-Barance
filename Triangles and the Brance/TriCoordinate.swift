//
//  File.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import Foundation
import SwiftUI
///描画のベースになる座標系、x、yが描画の頂点の座標を表す
struct TriCoordinate:Hashable{
    init(x:Int,y:Int){
        vertexX = x
        vertexY = y
    }
    let vertexX:Int
    let vertexY:Int
    
    func getNextCoordinate() ->[TriCoordinate] {
        [TriCoordinate(x: vertexX-1 , y: vertexY ),
         TriCoordinate(x: vertexX , y: vertexY-1 ),
         TriCoordinate(x: vertexX+1 , y: vertexY-1 ),
         TriCoordinate(x: vertexX+1 , y: vertexY ),
         TriCoordinate(x: vertexX , y: vertexY+1 ),
         TriCoordinate(x: vertexX-1 , y: vertexY-1 )]
    }
    
    func getDrowPoint() -> CGPoint{
        let X = Double(vertexX)
        let Y = Double(vertexY)
        return CGPoint(x: X + Y/2, y: Y * sqrt(3)/2 )
    }
    
}
    
struct TriLine:Hashable{
    let l:TriCoordinate
    let r:TriCoordinate
    
}


protocol TriShapeData{
    var modelCoordinates: [TriCoordinate]{ get }
    var outlines:Set<TriLine>{ get }
}

extension TriShapeData{
    var outlines:Set<TriLine>{
        var lines:Set<TriLine> = []
        //それぞれの座標に対して隣接しているマスの中から図形に含まれるものを取り出す
        for coordinate in modelCoordinates{
            let next = coordinate.getNextCoordinate()
            if let nextCoordinate =
                next.filter({ next in
                    next == coordinate}).first
                //ここから if文の中身
            {
                lines.insert(TriLine(l: coordinate, r: nextCoordinate))
            }
        }
        return lines
    }
}

