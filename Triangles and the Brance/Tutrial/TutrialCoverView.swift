//
//  TutrialCoverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/14.
//

import SwiftUI

struct TutrialCoverView: View {
    
    let anchor: Anchor<CGRect>

    var body: some View {
        GeometryReader{ geometry in
            Color.black
                .opacity(0.3)
                .mask{
                    ShapeWithSquareHole(clipRect: geometry[anchor])
                        .fill(style: .init(eoFill: true))
                }
                .contentShape(ShapeWithSquareHole(clipRect: geometry[anchor]),eoFill: true)
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
        }
    }
}

struct ShapeWithSquareHole: Shape {
    let clipRect: CGRect
    
    func path(in rect: CGRect) -> Path {
        var path = Path(rect)
        path.addRoundedRect(in: clipRect, cornerSize: CGSize(width: 10, height: 10))
        return path
    }
}
