//
//  SwiftUIView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/28.
//

import SwiftUI

///右下の端が欠けている四角形
struct RightCornerCutRectangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - rect.height, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: .zero)
        path.closeSubpath()
        return path
    }
}

///左上の端が欠けている四角形
struct LeftCornerCutRectangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.height, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width , y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: rect.height, y: 0))
        path.closeSubpath()
        return path
    }
}

///右上に出っ張りがある四角形
struct RectangleWithTextSpace: Shape {
    let textSpaceWidth: CGFloat
    let textSpaceHeight: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.width - textSpaceWidth, y: 0))
        path.addLine(to: CGPoint(x: rect.width - textSpaceWidth + textSpaceHeight, y: 0 - textSpaceHeight))
        path.addLine(to: CGPoint(x: rect.width, y: 0 - textSpaceHeight))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height + textSpaceHeight))
        path.addLine(to: CGPoint(x: rect.width - textSpaceWidth + textSpaceHeight, y: rect.height + textSpaceHeight))
        path.addLine(to: CGPoint(x: rect.width - textSpaceWidth , y: rect.height ))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: .zero)
        path.closeSubpath()
        return path
    }
}
