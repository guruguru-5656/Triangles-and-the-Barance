//
//  ActionItemHourglassView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/22.
//

import SwiftUI

struct ActionItemHourglassView: View {
    let stageColor: StageColor
    let size: CGFloat
    
    var body: some View {
        ZStack {
            TriangleNormalShape()
                .fill(stageColor.light)
                .overlay {
                    TriangleNormalShape()
                        .stroke(stageColor.heavy, lineWidth: 1)
                }
                .frame(width: size, height: size)
            HourGlassShape()
                .stroke(stageColor.heavy, lineWidth: 1.5)
                .frame(width: size * 0.3, height: size * 0.3)
                .offset(x: 0, y: size * 0.05)
        }
    }
}

struct ActionItemHourglassView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHourglassView(stageColor: StageColor(stage: 1), size: 100)
    }
}

struct HourGlassShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: rect.origin)
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
            path.closeSubpath()
        }
    }
}
