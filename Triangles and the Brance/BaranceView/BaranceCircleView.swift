//
//  BaranceCircleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

struct BaranceCircleView: View {
    @EnvironmentObject var gameModel: GameModel
    @ObservedObject var baranceViewContloller = GameModel.shared.baranceViewContloller
    @Binding var circlePoint: CGPoint
    var body: some View {
    GeometryReader { geometry in
        ZStack {
        gameModel.currentColor.previousColor.heavy
            .frame(width: gameModel.screenBounds.width, height: gameModel.screenBounds.height)
            .ignoresSafeArea()
            if baranceViewContloller.clearCircleIsOn {
                Ellipse()
                    .fill(gameModel.currentColor.heavy)
                    .frame(width: baranceViewContloller.clearCircleSize * 2,
                           height: baranceViewContloller.clearCircleSize)
                    .position(circlePoint)
                Ellipse()
                    .stroke(gameModel.currentColor.light, lineWidth: 5)
                    .frame(width: baranceViewContloller.clearCircleSize * 2,
                           height: baranceViewContloller.clearCircleSize)
                    .position(circlePoint)
            }
            LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.3)
            .ignoresSafeArea()
        }
    }
    .ignoresSafeArea()
    }
}
