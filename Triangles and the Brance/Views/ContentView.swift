//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject var stageModel = StageModel()
    @State var circleAncor: Anchor<CGRect>?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                stageModel.currentColor.previousColor.heavy
                    .ignoresSafeArea()
                if let circleAncor = circleAncor {
                    let rect = geometry[circleAncor]
                    let point = CGPoint(x: rect.origin.x + rect.width/8, y: rect.origin.y + rect.width * 3/8)
                    BaranceCircleView(circlePoint: point)
                }
                LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.3)
                    .ignoresSafeArea()
                StageView()
                if stageModel.showResultView && !stageModel.isGameClear  {
                    Color(.init(gray: 0.3, alpha: 0.6))
                        .ignoresSafeArea()
                    ResultView()
                        .cornerRadius(10)
                        .padding(30)
                }
                if stageModel.isGameClear {
                    if let circleAncor = circleAncor {
                        let rect = geometry[circleAncor]
                        let point = CGPoint(x: rect.origin.x + rect.width/8, y: rect.origin.y + rect.width * 3/8)
                        BaranceCircleView(circlePoint: point)
                        if !stageModel.showResultView {
                            LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .opacity(0.3)
                                .ignoresSafeArea()
                                .mask(BaranceCircleView(circlePoint: point))
                        }
                    }
                    if stageModel.showResultView {
                        stageModel.currentColor.heavy
                            .ignoresSafeArea()
                        LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .opacity(0.3)
                            .ignoresSafeArea()
                        ResultView()
                            .cornerRadius(10)
                            .padding(30)
                    }
                }
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { value in
            circleAncor = value
        }
        .environmentObject(stageModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
