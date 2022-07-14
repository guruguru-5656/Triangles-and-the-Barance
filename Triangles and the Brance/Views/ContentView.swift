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
    
    var body: some View {
        ZStack {
            BaranceCircleView(circlePoint: $circlePoint)
                .ignoresSafeArea()
            StageView()
            if stageModel.showResultView {
                Color(.init(gray: 0.5, alpha: 0.6))
                    .ignoresSafeArea()
                ResultView()
                    .cornerRadius(10)
                    .padding(30)
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { point in
            circlePoint = point }
        .coordinateSpace(name: "contentView")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
