//
//  TitleBaranceObject.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/09.
//

import SwiftUI

struct TitleBaranceObject: View {
    let stage: Int
    private var titleColor: StageColor {
        StageColor(stage: stage)
    }
    private var angle: Double {
        (1 - Double(stage) / 6) * Double.pi/16
    }
    
    var body: some View {
        GeometryReader { geometry in
            let baseScale: CGFloat = geometry.size.width / 8
            let distance: Double = baseScale * 3.25 * sin(angle)
            //左右に伸びる棒
            Group {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: baseScale / 8, height: baseScale * 1.5)
                    .position(x: baseScale * 1, y: baseScale * 1.25 - distance)
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: baseScale / 8, height: baseScale * 1.5)
                    .position(x: baseScale * 7, y: baseScale * 1.25 + distance)
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.lightGray)
                    .frame(width: baseScale * 6.5, height: baseScale / 4)
                    .rotationEffect(Angle(radians: angle))
                    .position(x: baseScale * 4, y: baseScale * 0.5)
            }
            //中央部分
            Group {
                Rectangle()
                    .foregroundColor(.lightGray)
                    .frame(width: baseScale / 4, height: baseScale * 2)
                    .position(x: baseScale * 4, y: baseScale * 1.5)
                TriangleNormalShape()
                    .frame(width: baseScale * 2, height: baseScale * 2 * sqrt(3)/2)
                    .foregroundColor(titleColor.light)
                    .position(x:baseScale * 4, y: baseScale * 2.8)
                RegularPolygon(vertexNumber: 6)
                    .foregroundColor(.gray)
                    .frame(width:baseScale * 0.8, height:baseScale * 0.8)
                    .position(x: baseScale * 4, y: baseScale * 0.5)
            }
            //右側
            TriangleNormalShape()
                .foregroundColor(.gray)
                .frame(width: baseScale * sqrt(3), height: baseScale *
                       1.5 )
                .position(x: baseScale * 7, y: baseScale * 2 + distance)
            //左側の三角形
            TriangleNormalShape()
                .foregroundColor(.backgroundLightGray)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 1, y: baseScale * 1.8 - distance)
        }
    }
}

struct TitleBaranceObject_Previews: PreviewProvider {
    static var previews: some View {
        TitleBaranceObject(stage: 1)
    }
}
