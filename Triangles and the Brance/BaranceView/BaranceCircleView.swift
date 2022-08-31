//
//  BaranceCircleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

struct BaranceCircleView: View {
    
    @EnvironmentObject private var viewEnvironment: ViewEnvironment
    @ObservedObject private var model = GameModel.shared.baranceViewModel
    let circlePoint: CGPoint
    
    var body: some View {
        GeometryReader { geometry in
            let axisX = geometry.size.width / 20
            let axisY = geometry.size.width / 40
            let scaleX = geometry.size.width / axisX
            let scaleY = geometry.size.height / axisY
            let scale = sqrt(pow(scaleX, 2) + pow(scaleY, 2))
            ZStack {
                viewEnvironment.currentColor.previousColor.heavy
                    .ignoresSafeArea()
                LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.3)
                    .ignoresSafeArea()
                Section {
                    Ellipse()
                        .fill(viewEnvironment.currentColor.light)
                        .scaleEffect(model.clearCircleIsOn ? scale : 1)
                    Ellipse()
                        .fill(viewEnvironment.currentColor.heavy)
                        .scaleEffect(model.clearCircleIsOn ? scale - 0.3 : 0.7)
                }
                .frame(width: axisX * 2, height: axisY * 2)
                .position(circlePoint)
            }
        }
    }
}


