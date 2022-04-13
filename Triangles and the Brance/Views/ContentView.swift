//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameModel: GameModel
    @State var circlePoint = CGPoint(x: 0, y: 0)
    @ObservedObject var baranceViewContloller = GameModel.shared.baranceViewContloller
    var body: some View {
        
        ZStack {
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
            StageView()
            
            if gameModel.showGameOverView {
                
                Color(.init(gray: 0.4, alpha: 0.5))
                    .ignoresSafeArea()
                    .zIndex(1)
                GameOverView()
                    .cornerRadius(20)
                    .padding(40)
                    .zIndex(1)
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { point in
            circlePoint = point
        }
    }
        
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameModel.shared)
    }
}
