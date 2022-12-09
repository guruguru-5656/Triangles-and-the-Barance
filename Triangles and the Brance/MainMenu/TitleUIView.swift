//
//  TitleUIView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/04.
//

import SwiftUI

struct TitleUIView: View {
    private let bgmPlayer = BGMPlayer.shared
    private let soundPlayer = SEPlayer.shared
    let stageData = SaveData.shared.loadData(name: ResultValue.stage)
    @Binding var mainView: MainView
    @State private var isShowPopUp: Bool = false
    @State private var popUp: PopUp?
    
    private var stage: Int {
        //0(データが存在しない場合）は１にする
        stageData == 0 ? 1 : stageData
    }
    
    private var titleColor: StageColor {
        StageColor(stage: stage)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                titleColor.previousColor.heavy
                    .ignoresSafeArea()
                LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.3)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Triance")
                        .font(.smartFontUI(fixedSize: 80))
                        .bold()
                        .foregroundColor(.backgroundLightGray)
                    TitleBaranceObject(stage: stage)
                    .frame(height: proxy.size.width * 0.4)
                    .padding(.horizontal)
                    Spacer()
                    HexagonMenuView(cellModels: MainMenus.allCases.map { menu in
                        MainMenuCellModel(menu: menu, action: { transition(to: menu) })
                    })
                    .padding(.horizontal, proxy.size.width * 0.1)
                    .frame(height: proxy.size.width * 0.7)
                    Spacer()
                }
                if isShowPopUp {
                    if let popUp = popUp {
                        PopUpView {
                            switch popUp {
                            case .highScore:
                                HighScoreView(isShow: $isShowPopUp)
                            case .setting:
                                SoundSettingView(isShow: $isShowPopUp)
                            case .upgrade:
                                UpgradeView(showUpgradeView: $isShowPopUp)
                            }
                        }
                        .padding(20)
                        .transition(.opacity)
                    }
                }
            }
        }
        .onAppear {
            bgmPlayer.play(bgm: .title)
        }
    }
    
    func startGame(of view: MainView) {
        withAnimation {
            mainView = view
        }
        bgmPlayer.play(bgm: view.bgm)
        soundPlayer.play(sound: .decideSound)
    }
    
    private func transition(to menu: MainMenus) {
        switch menu {
        case .tutrial:
            startGame(of: .tutrial)
        case .game:
            startGame(of: .game)
        case .upgrade:
            show(popUp: .upgrade)
        case .highScore:
            show(popUp: .highScore)
        case .setting:
            show(popUp: .setting)
        }
    }
    
    private func show(popUp: PopUp) {
        soundPlayer.play(sound: .decideSound)
        withAnimation {
            self.isShowPopUp = true
            self.popUp = popUp
        }
    }
    
    enum PopUp {
        case upgrade
        case highScore
        case setting
    }
}

struct TitleUIView_Previews: PreviewProvider {
    @State static var view: MainView = .title
    static var previews: some View {
        TitleUIView(mainView: $view)
    }
}


