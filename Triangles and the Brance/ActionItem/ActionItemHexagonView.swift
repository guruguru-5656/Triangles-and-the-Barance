//
//  ActionItem_HexagonView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/28.
//

import SwiftUI

struct ActionItemHexagonView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @ObservedObject var itemController = GameModel.shared.itemController
    let size: CGFloat
    var body: some View {
        RegularPolygon(vertexNumber: 6)
            .fill(viewEnvironment.currentColor.light)
            .overlay {
                RegularPolygon(vertexNumber: 6)
                    .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
            }
            .frame(width: size, height: size)
    }
}

struct ActionItem_HexagonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHexagonView(size: 10)
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
