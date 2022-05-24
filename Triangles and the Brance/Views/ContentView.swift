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
    
    var body: some View {
        
        ZStack {
            BaranceCircleView(circlePoint: $circlePoint)
            StageView()
            
            if gameModel.showGameOverView {
                Color(.init(gray: 0.4, alpha: 0.5))
                    .ignoresSafeArea()
                GameOverView()
                    .cornerRadius(20)
                    .padding(40)
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
