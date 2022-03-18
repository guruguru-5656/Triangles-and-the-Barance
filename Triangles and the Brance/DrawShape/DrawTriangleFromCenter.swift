//
//  DrawTriangleFromCenter.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/17.
//

import SwiftUI


///正三角形を描画するShape
///回転エフェクトを正常に機能させるために、呼出時はwidth:heightが1:1/sqrt(3)の比率になるように呼びだす
struct DrawTriangleFromCenter:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxX * sqrt(3)/2))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
    
}

///DrawTriangleFromCenterを呼び出すときに必要なパラメータを設定する
///位置ずれしないように高さの比率を指定
protocol DrawTriangle:View{
    var width:CGFloat{ get }
    var height:CGFloat{ get }
}
///高さの値をスケールから決定する
extension DrawTriangle{
    var height:CGFloat{
        width * 1/sqrt(3)
    }
}
