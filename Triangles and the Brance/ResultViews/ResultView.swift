//
//  GameOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/03.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject private var score = GameModel.shared.score
    @State private var opacity: Double = 0
    @State private var showUpgradeView = false
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 20) {
                Text((score.results[0].value == 12 ? "Final Result" : "Result"))
                    .font(.largeTitle)
                    .padding(.vertical)
                    .background(
                        Rectangle()
                            .frame(width: geometry.size.width)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    )
                if !showUpgradeView {
                    Section {
                        Section {
                            ForEach($score.results) { $results in
                                ScoreView(score: $results)
                                    .opacity(opacity)
                                    .animation(.default.delay(Double(results.index) * 0.2), value: opacity)
                            }
                        }
                        .padding(.horizontal, geometry.size.width * 0.1)
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: {
                                GameModel.shared.resetGame()
                                withAnimation {
                                    GameModel.shared.stageModel.showResultView = false
                                }
                            }){
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Retry")
                                }
                                .foregroundColor(Color.heavyRed)
                            }
                            .buttonStyle(CustomButton())
                            Button(action: {
                                withAnimation{
                                    showUpgradeView = true
                                }
                            }){
                                HStack {
                                    Image(systemName: "arrowtriangle.up")
                                    Text("Upgrade")
                                }
                                .foregroundColor(.heavyGreen)
                            }
                            .buttonStyle(CustomButton())
                        }
                        .frame(height: 50)
                        .onAppear{
                            opacity = 1
                        }
                        Spacer()
                    }.transition(.move(edge: .top).combined(with: .opacity))
                }
                if showUpgradeView {
                    UpgradeView(showUpgradeView: $showUpgradeView)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .background(Color(white: 0.95, opacity: 0.8))
        .transition(.opacity)
    }
}

struct ScoreView: View {
    @Binding var score: ResultModel
    
    var body: some View {
        HStack {
            Text(score.text)
                .font(.title)
            Spacer()
            Text(String(score.value))
                .font(.title)
            if score.isUpdated{
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(Color.heavyRed)
            }
        }
    }
}
