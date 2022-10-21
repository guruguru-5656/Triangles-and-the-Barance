//
//  GameOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/03.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject private var stageModel: StageModel
    @StateObject private var resultViewModel = ResultViewModel()
    @State private var opacity: Double = 0
    @State private var showUpgradeView = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(stageModel.isGameClear ? "Game Result" : "Result")
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
                        ForEach($resultViewModel.results) { $results in
                            ScoreView(score: $results)
                                .opacity(opacity)
                                .animation(.default.delay(Double(results.index) * 0.2), value: opacity)
                            
                        }
                        
                        Spacer()
                        HStack(spacing: 20) {
                            Button(action: {
                                resultViewModel.closeResult()
                            }){
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Retry")
                                }
                                .foregroundColor(Color.heavyRed)
                            }
                            .buttonStyle(CustomButton())
                            Button(action: {
                                resultViewModel.playDecideSound()
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
                        .onDisappear {
                            resultViewModel.loadTotalPointData()
                        }
                }
            }
        }
        .background(Color(white: 1, opacity: 0.9))
        .transition(.opacity)
        .onAppear {
            resultViewModel.depend(stageModel: stageModel)
            resultViewModel.showScores()
        }
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
        .padding(.vertical, 10)
        .padding(.horizontal, 30)
        .background(Color(white: score.index % 2 == 0 ? 0.85 : 0.9))
    }
}
