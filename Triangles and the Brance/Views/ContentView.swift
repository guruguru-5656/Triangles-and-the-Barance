//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameModel: GameModel
    var body: some View {
        ZStack {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameModel.shared)
    }
}
