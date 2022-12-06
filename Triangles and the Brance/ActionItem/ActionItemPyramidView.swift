//
//  ActionItem_Triforce.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/18.
//

import SwiftUI


struct NormalActionView: View{
    let stageColor: StageColor
    let size: CGFloat
    
    var body: some View {
        TriangleNormalShape()
            .fill(stageColor.light)
            .overlay {
                TriangleNormalShape()
                    .stroke(stageColor.heavy, lineWidth: 1)
            }
            .frame(width: size, height: size)
    }
}

struct PyramidItemView: View{
    let stageColor: StageColor
    let size:CGFloat
    
    var body: some View {
        ZStack{
            TriangleNormalShape()
                .fill(stageColor.light)
            TriangleNormalShape()
                .stroke(stageColor.heavy, lineWidth: 1)
            TriangleNormalShape()
                .stroke(stageColor.heavy, lineWidth: 2)
                .scaleEffect(0.5)
                .rotationEffect(Angle(degrees: 180))
        }
        .frame(width: size, height: size)
    }
}

struct TriangleNormalShape:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        path.addLine(to:CGPoint(x: rect.width * (2-sqrt(3))/4 , y: rect.height * 3/4))
        path.addLine(to: CGPoint(x: rect.width * (2+sqrt(3))/4, y: rect.height * 3/4))
        path.addLine(to: CGPoint(x: rect.width/2, y: 0))
        path.closeSubpath()
        return path
    }
}

