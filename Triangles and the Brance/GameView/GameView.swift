//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct GameView: View {
    @Binding var mainView: MainView
    @ObservedObject var gameModel = GameModel()
    @State private var isShowPopup = false
    @State private var circleAncor: Anchor<CGRect>?
    private let soundPlayer = SEPlayer.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                gameModel.currentColor.previousColor.heavy
                    .ignoresSafeArea()
                LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.3)
                    .ignoresSafeArea()
                if let circleAncor = circleAncor {
                    let rect = geometry[circleAncor]
                    let point = CGPoint(x: rect.origin.x + rect.width / 8, y: rect.origin.y + rect.width * 3/8)
                    BaranceCircleView(circlePoint: point)
                        .zIndex(gameModel.isGameClear ? 1 : 0)
                    LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .mask(BaranceCircleView(circlePoint: point))
                        .zIndex(gameModel.isGameClear ? 1 : 0)
                }
                StageView(isShowPopup: $isShowPopup)
                if isShowPopup {
                    PopUpView {
                        VStack {
                            Button(action: {
                                gameModel.gameOver()
                                isShowPopup = false
                            }){
                                HStack {
                                    Image(systemName: "flag.fill")
                                    Text("GiveUp")
                                }
                                .foregroundColor(Color.heavyGreen)
                            }
                            .buttonStyle(CustomButton())
                            HStack(spacing: 20) {
                                Button(action: {
                                    soundPlayer.play(sound: .cancelSound)
                                    withAnimation {
                                        isShowPopup = false
                                    }
                                }){
                                    HStack {
                                        Image(systemName: "xmark")
                                        Text("Close")
                                    }
                                    .foregroundColor(Color.heavyRed)
                                }
                                .buttonStyle(CustomButton())
                                Button(action: {
                                    soundPlayer.play(sound: .decideSound)
                                    isShowPopup = false
                                    mainView = .title
                                }){
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                        Text("Exit")
                                    }
                                    .foregroundColor(Color.heavyGreen)
                                }
                                .buttonStyle(CustomButton())
                            }
                            .frame(height: 50)
                        }
                    }
                }
                if gameModel.showResultView {
                    Color(.init(gray: 0.3, alpha: gameModel.isGameClear ? 0 : 0.6))
                        .ignoresSafeArea()
                    ResultView()
                        .cornerRadius(10)
                        .padding(30)
                        .zIndex(1)
                }
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { value in
            circleAncor = value
        }
        .environmentObject(gameModel)
        .navigationBarHidden(true)
    }
}

struct GameView_Previews: PreviewProvider {
    @State static private var mainView: MainView = .game
    static var previews: some View {
        GameView(mainView: $mainView)
    }
}
