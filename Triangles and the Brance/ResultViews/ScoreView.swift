//
//  GameOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/03.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var score = GameModel.shared.score
    @State var opacity: Double = 0
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 20) {
                Text("Result")
                    .font(.largeTitle)
                    .padding(30)
                if !score.showUpgrade{
                    Section {
                        Section {
                            ForEach($score.results) { $results in
                                ScoreView(score: $results)
                                    .opacity(opacity)
                                    .animation(.default.delay(Double(results.index) * 0.1), value: opacity)
                            }
                            HStack {
                                Text("Money")
                                    .font(.title)
                                Spacer()
                                Text(String(score.money))
                                    .font(.title)
                            }
                            .opacity(opacity)
                            .animation(.default.delay(Double(score.results.count) * 0.1), value: opacity)
                        }
                        .padding(.horizontal, geometry.size.width * 0.1)
                        
                        HStack (alignment: .center) {
                            Button(action: {
                                GameModel.shared.resetGame()
                                withAnimation {
                                    GameModel.shared.showGameOverView = false
                                }
                                
                            }){
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.vertical, 15)
                                    
                                    Text("Retry")
                                        .font(.title2)
                                }
                            }
                            .padding(.horizontal)
                            .foregroundColor(Color.heavyRed)
                            .border(Color.heavyRed, width: 2)
                            Button(action: {
                                withAnimation{
                                    score.showUpgrade = true
                                }
                            }){
                                HStack {
                                    Image(systemName: "arrowtriangle.up")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.vertical, 15)
                                    
                                    Text("Upgrade")
                                        .font(.title2)
                                }
                            }
                            .padding(.horizontal)
                            .foregroundColor(.heavyYellowGreen)
                            .border(Color.heavyYellowGreen, width: 2)
                        }
                        .frame(height: 50)
                        .padding()
                        .onAppear{
                            opacity = 1
                        }
                    }.transition(.move(edge: .top).combined(with: .opacity))
                }
                if score.showUpgrade {
                    UpgradeView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .background(.white)
        .transition(.asymmetric(insertion: .move(edge: .bottom),
                                removal: .opacity
                                    .animation(.easeOut(duration: 0.3).delay(0.1))
                                    .combined(with: .scale(scale: 1.1))
                                    .animation(.easeOut(duration: 0.3))))
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
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .rotationEffect(Angle(degrees: 90))
                    .foregroundColor(.red)
            }
        }
    }
}
