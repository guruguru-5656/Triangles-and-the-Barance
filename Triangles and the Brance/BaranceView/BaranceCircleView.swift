//
//  BaranceCircleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

struct BaranceCircleView: View {
    
    @EnvironmentObject private var viewEnvironment: ViewEnvironment
    @ObservedObject private var contloller = GameModel.shared.baranceViewContloller
    @Binding var circlePoint: CGPoint
    var body: some View {
        ZStack {
        viewEnvironment.currentColor.previousColor.heavy
            .ignoresSafeArea()
            if contloller.clearCircleIsOn {
                Ellipse()
                    .fill(viewEnvironment.currentColor.heavy)
                    .frame(width: contloller.clearCircleSize * 2,
                           height: contloller.clearCircleSize)
                    .position(circlePoint)
                Ellipse()
                    .stroke(viewEnvironment.currentColor.light, lineWidth: 5)
                    .frame(width: contloller.clearCircleSize * 2,
                           height: contloller.clearCircleSize)
                    .position(circlePoint)
            }
            LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.3)
        }
    }
}
