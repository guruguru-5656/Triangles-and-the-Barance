//
//  regularPolygon.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/11.
//

import SwiftUI

///直径がframe widthの長さになる円に内接する正多角形
///frame heightには依存しない
struct RegularPolygon: Shape {
    //頂点の数、正N角形にするかを決める
    let vertexNumber: Int
    
    func path(in rect: CGRect) -> Path {
        //半径1の円上の点を取る
        var vertex: [CGPoint] = []
        var angle: Double = 0
        for _ in 1 ... vertexNumber {
            vertex.append(CGPoint(x: cos(angle), y: sin(angle)))
            angle += Double.pi * 2 / Double(vertexNumber)
        }
        let points = vertex.map { vertex in
            CGPoint(x: (vertex.x + 1) * rect.maxX/2 , y: (vertex.y + 1) * rect.maxX/2)
        }
        var path = Path()
        path.addLines(points)
        path.closeSubpath()
        return path
    }
}
