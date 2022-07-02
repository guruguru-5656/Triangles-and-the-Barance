//
//  ActionItemLargePyramid.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/02.
//

import SwiftUI

struct ActionItemHexagramView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @ObservedObject var itemController = GameModel.shared.itemController
    let size: CGFloat
    var body: some View {
        ZStack{
            RegularPolygon(vertexNumber: 6)
                .fill(viewEnvironment.currentColor.light)
            RegularPolygon(vertexNumber: 6)
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
            TriangleNormalShape()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.6)
            TriangleNormalShape()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.6)
                .rotationEffect(Angle(degrees: 180))
        }
            .frame(width: size, height: size)
    }
}

struct ActionItemLargePyramid_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemHexagramView(size: 80)
            .environmentObject(ViewEnvironment())
    }
}
