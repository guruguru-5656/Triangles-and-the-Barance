//
//  ActionItemLargePyramid.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/02.
//

import SwiftUI

struct ActionItemHexagramView: View {
    @EnvironmentObject var stageModel: StageModel
    let size: CGFloat
    var body: some View {
        ZStack{
            RegularPolygon(vertexNumber: 6)
                .fill(stageModel.currentColor.light)
            RegularPolygon(vertexNumber: 6)
                .stroke(stageModel.currentColor.heavy, lineWidth: 1)
            TriangleNormalShape()
                .stroke(stageModel.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.6)
            TriangleNormalShape()
                .stroke(stageModel.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.6)
                .rotationEffect(Angle(degrees: 180))
        }
            .frame(width: size, height: size)
    }
}

struct ActionItemLargePyramid_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHexagramView(size: 80)
            .environmentObject(StageModel())
    }
}
