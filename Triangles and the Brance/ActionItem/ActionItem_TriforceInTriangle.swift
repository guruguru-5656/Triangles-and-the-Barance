//
//  ActionItem_TriforceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import SwiftUI

struct ActionItem_TriforceView: View {
    @EnvironmentObject var stage:GameModel
    let width:CGFloat
    let height:CGFloat 
    var body: some View {
        DrawTriangleFromCenter()
            .stroke(stage.currentColor.heavy, lineWidth: 2)
            .scaleEffect(0.8)
            .frame(width: width, height: height, alignment: .top)
        DrawTriangleFromCenter()
            .stroke(stage.currentColor.heavy, lineWidth: 2)
            .scaleEffect(0.4)
            .rotationEffect(Angle(degrees: 180))
            .frame(width: width, height: height, alignment: .top)
    }
}
