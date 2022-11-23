//
//  ActionItemTriHexagon.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/23.
//

import SwiftUI

struct ActionItemTriHexagonView: View {
    let stageColor: StageColor
    let size: CGFloat
    
    var body: some View {
        ZStack {
            RegularPolygon(vertexNumber: 6)
                .fill(stageColor.light)
            RegularPolygon(vertexNumber: 6)
                .stroke(stageColor.heavy, lineWidth: 1)
            TriangleNormalShape()
                .stroke(stageColor.heavy, lineWidth: 2)
                .scaleEffect(0.7)
                .rotationEffect(Angle(degrees: 30))
        }
        .frame(width: size, height: size)
    }
}

struct ActionItemTriHexagonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemTriHexagonView(stageColor: StageColor(stage: 1), size: 100)
    }
}
