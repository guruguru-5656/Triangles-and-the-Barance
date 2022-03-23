//
//  DrawTriShape.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import SwiftUI

///TriVertexCoordinate座標系から頂点を設定、描画を行う
struct DrawShapeFromVertexCoordinate:Shape{
    //初期値
    let coordinates:[TriVertexCoordinate]
    let scale:CGFloat
    var drawPoint:[CGPoint]{
        coordinates.map{ coordinate in
            CGPoint(x: coordinate.drawPoint.x * scale,
                    y: coordinate.drawPoint.y * scale)}
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: drawPoint[0])
            let linePoint = drawPoint[1...drawPoint.count-1]
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
    init(start:TriVertexCoordinate, end:TriVertexCoordinate,scale:CGFloat){
        self.startCoordinate = start
        self.endCoordinate = end
        self.scale = scale
    }
    
    let startCoordinate:TriVertexCoordinate
    let endCoordinate:TriVertexCoordinate
    let scale:CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: startCoordinate.drawPoint.x * scale, y: startCoordinate.drawPoint.y * scale))
        path.addLine(to: CGPoint(x: endCoordinate.drawPoint.x * scale, y: endCoordinate.drawPoint.y * scale))
        return path
    }
}


