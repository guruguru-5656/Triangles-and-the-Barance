//
//  ActionItem_HexagonView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/28.
//

import SwiftUI

struct ActionItemHexagonView: View {
    let stageColor: StageColor
    let size: CGFloat
    var body: some View {
        RegularPolygon(vertexNumber: 6)
            .fill(stageColor.light)
            .overlay {
                RegularPolygon(vertexNumber: 6)
                    .stroke(stageColor.heavy, lineWidth: 1)
            }
            .frame(width: size, height: size)
    }
}

struct ActionItem_HexagonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHexagonView(stageColor: StageColor(stage: 1), size: 10)
            .environmentObject(GameModel())
    }
}
