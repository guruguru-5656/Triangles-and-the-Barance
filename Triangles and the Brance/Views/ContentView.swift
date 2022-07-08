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
                .blur(radius: stageModel.showResultView ? 3.0 : 0)
            if stageModel.showResultView {
                Color(.init(gray: 0.4, alpha: 0.5))
                    .ignoresSafeArea()
                ResultView()
                    .cornerRadius(10)
                    .padding(30)
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { point in
            circlePoint = point }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
