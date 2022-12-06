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
                .contentShape(ShapeWithSquareHole(clipRect: geometry[anchor]), eoFill: true)
                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5)
        }
    }
}

struct ShapeWithSquareHole: Shape {
    
    let clipRects: [CGRect]
    
    init(clipRect: CGRect...) {
        self.clipRects = clipRect
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path(rect)
        for clipRect in clipRects {
            let scale = 1.1
            let scaledRect = CGRect(origin: CGPoint(x:clipRect.origin.x - clipRect.width * (scale - 1)/2,
                                                    y: clipRect.origin.y - clipRect.height * (scale - 1)/2),
                                    size: CGSize(width: clipRect.width * scale, height: clipRect.height * scale))
            path.addRoundedRect(in: scaledRect, cornerSize: CGSize(width: 10, height: 10))
        }
        return path
    }
}
