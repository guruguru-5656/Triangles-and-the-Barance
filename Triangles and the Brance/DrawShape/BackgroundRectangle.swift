////
////  SwiftUIView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/28.
//

import SwiftUI

///右上の端が欠けている四角形
struct RightCornerCutRectangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width + rect.height, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: .zero)
        path.closeSubpath()
        return path
    }
}
