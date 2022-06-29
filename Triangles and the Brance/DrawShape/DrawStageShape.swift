//
//  DrawTriShape.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import SwiftUI

///頂点の座標系から描画を行う
struct DrawShapeFromVertexCoordinate:Shape{
    //初期値
    let coordinates:[TriangleVertexCoordinate]
    let scale:CGFloat
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: coordinates[0].drawPoint.scale(scale))
            let linePoint = coordinates.dropFirst().map {
                $0.drawPoint.scale(scale)
            }
            linePoint.forEach{
                path.addLine(to: $0)
            }
            path.closeSubpath()
        }
    }
}


struct DrawTriLine:Shape{
    init(line:TriLine,scale:CGFloat){
        startCoordinate = line.start
        endCoordinate = line.end
        self.scale = scale
    }
    init(start:TriangleVertexCoordinate, end:TriangleVertexCoordinate,scale:CGFloat){
        self.startCoordinate = start
        self.endCoordinate = end
        self.scale = scale
    }
    
    let startCoordinate:TriangleVertexCoordinate
    let endCoordinate:TriangleVertexCoordinate
    let scale:CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: startCoordinate.drawPoint.x * scale, y: startCoordinate.drawPoint.y * scale))
        path.addLine(to: CGPoint(x: endCoordinate.drawPoint.x * scale, y: endCoordinate.drawPoint.y * scale))
        return path
    }
}

struct TriLine:Hashable,Identifiable{
    let start:TriangleVertexCoordinate
    let end:TriangleVertexCoordinate
    var id = UUID()
}

