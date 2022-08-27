//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject var stageModel = GameModel.shared.stageModel
    @State var circlePoint = CGPoint(x: 0, y: 0)
    @EnvironmentObject private var viewEnvironment: ViewEnvironment
    var body: some View {
        ZStack {
            StageView()
            if stageModel.showResultView {
                Color(.init(gray: 0.3, alpha: 0.6))
                    .ignoresSafeArea()
                ResultView()
                    .cornerRadius(10)
                    .padding(30)
            }
        }
        .backgroundPreferenceValue(ClearCirclePoint.self) { value in
            value.map { values in
                GeometryReader { geometry in
                    let rect = geometry[values]
                    let point = CGPoint(x: rect.origin.x + rect.width/8, y: rect.origin.y + rect.width * 3/8)
                    BaranceCircleView(circlePoint: point)
                }
            }
        }
        .environmentObject(stageModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
