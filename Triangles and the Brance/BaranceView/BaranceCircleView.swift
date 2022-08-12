//
//  BaranceCircleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

struct BaranceCircleView: View {
    
    @EnvironmentObject private var viewEnvironment: ViewEnvironment
    @ObservedObject private var stageModel = GameModel.shared.stageModel
    let circlePoint: CGPoint
    var body: some View {
        //スクリーンの対角線の長さを楕円の短い方の半径の長さで割る
        let y = viewEnvironment.screenBounds.height
        let x = viewEnvironment.screenBounds.width
        let distance = sqrt(y * y + x * x)
        let scale = distance / 7.5
        ZStack {
            viewEnvironment.currentColor.previousColor.heavy
                .ignoresSafeArea()
            LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.3)
                .ignoresSafeArea()
            Section {
                Ellipse()
                    .fill(viewEnvironment.currentColor.light)
                    .scaleEffect(stageModel.clearCircleIsOn ? scale : 1)
                Ellipse()
                    .fill(viewEnvironment.currentColor.heavy)
                    .scaleEffect(stageModel.clearCircleIsOn ? scale - 0.3 : 0.7)
            }
            .frame(width: 30, height: 15)
            .position(circlePoint)
        }
    }
}


