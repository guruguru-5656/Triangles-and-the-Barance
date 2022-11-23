//
//  ActionItemHorizon.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/23.
//

import SwiftUI

struct ActionItemHorizon: View {
    let stageColor: StageColor
    let size: CGFloat
    
    var body: some View {
        TriangleNormalShape()
            .fill(stageColor.light)
            .overlay {
                TriangleNormalShape()
                    .stroke(stageColor.heavy, lineWidth: 1)
            }
            .overlay{
                HorizonShape()
                    .stroke(stageColor.heavy, lineWidth: 1.5)
                    .frame(width: size / 2.5, height: size / 2.5)
            }
            .frame(width: size, height: size)
    }
}

struct ActionItemHorizon_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHorizon(stageColor: StageColor(stage: 1), size: 80)
    }
}

struct HorizonShape:Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.2, y: rect.height * 0.425 ))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.425))
        path.addLine(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.75))
        path.move(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.575))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.height * 0.575))
        path.addLine(to: CGPoint(x: rect.width * 0.2, y: rect.height * 0.25))
               return path
    }
}
