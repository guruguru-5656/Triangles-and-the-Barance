//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct GameView: View {
    @Binding var mainView: MainView
    @ObservedObject var stageModel = StageModel()
    @State private var isShowPopup = false
    @State private var circleAncor: Anchor<CGRect>?
    private let soundPlayer = SoundPlayer.instance
    
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
                StageView(isShowPopup: $isShowPopup)
                if isShowPopup {
                    PopUpView {
                        VStack {
                            Button(action: {
                                stageModel.giveUp()
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
                                        Text("Cancel")
                                    }
                                    .foregroundColor(Color.heavyRed)
                                }
                                .buttonStyle(CustomButton())
                                Button(action: {
                                    soundPlayer.play(sound: .decideSound)
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
        .navigationBarHidden(true)
    }
}

struct GameView_Previews: PreviewProvider {
    @State static private var mainView: MainView = .game
    static var previews: some View {
        GameView(mainView: $mainView)
    }
}
