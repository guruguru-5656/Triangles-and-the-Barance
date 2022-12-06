//
//  ActionItemLargePyramid.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/02.
//

import SwiftUI

struct ActionItemHexagramView: View {
    let stageColor: StageColor
    let size: CGFloat
    var body: some View {
        ZStack{
            RegularPolygon(vertexNumber: 6)
                .fill(stageColor.light)
            RegularPolygon(vertexNumber: 6)
                .stroke(stageColor.heavy, lineWidth: 1)
            TriangleNormalShape()
                .stroke(stageColor.heavy, lineWidth: 2)
                .scaleEffect(0.6)
            TriangleNormalShape()
                .stroke(stageColor.heavy, lineWidth: 2)
                .scaleEffect(0.6)
                .rotationEffect(Angle(degrees: 180))
        }
            .frame(width: size, height: size)
    }
}

struct ActionItemLargePyramid_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHexagramView(stageColor: StageColor(stage: 1), size: 80)
    }
}
