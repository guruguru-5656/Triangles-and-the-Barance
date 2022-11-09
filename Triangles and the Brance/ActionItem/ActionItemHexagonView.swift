//
//  ActionItem_HexagonView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/28.
//

import SwiftUI

struct ActionItemHexagonView: View {
    @EnvironmentObject var stageModel: StageModel
    let size: CGFloat
    var body: some View {
        RegularPolygon(vertexNumber: 6)
            .fill(stageModel.currentColor.light)
            .overlay {
                RegularPolygon(vertexNumber: 6)
                    .stroke(stageModel.currentColor.heavy, lineWidth: 1)
            }
            .frame(width: size, height: size)
    }
}

struct ActionItem_HexagonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHexagonView(size: 10)
            .environmentObject(StageModel())
    }
}
