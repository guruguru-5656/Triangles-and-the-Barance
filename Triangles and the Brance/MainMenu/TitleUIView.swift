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
    private let titleColor = StageColor(stage: 1)
    @Binding var mainView: MainView
    @State private var isShowPopUp: Bool = false
    @State private var popUp: PopUp?
    
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
                    GeometryReader { geometry in
                        let baseScale: CGFloat = geometry.size.width / 8
                        //左右に伸びる棒
                        Group {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: baseScale / 8, height: baseScale * 1.5)
                                .position(x: baseScale * 1, y: baseScale * 1.25)
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(width: baseScale / 8, height: baseScale * 1.5)
                                .position(x: baseScale * 7, y: baseScale * 1.25)
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(.lightGray)
                                .frame(width: baseScale * 6.5, height: baseScale / 4)
                                .position(x: baseScale * 4, y: baseScale * 0.5)
                        }
                        //中央部分
                        Group {
                            Rectangle()
                                .foregroundColor(.lightGray)
                                .frame(width: baseScale / 4, height: baseScale * 2)
                                .position(x: baseScale * 4, y: baseScale * 1.5)
                            TriangleNormalShape()
                                .frame(width: baseScale * 2, height: baseScale * 2 * sqrt(3)/2)
                                .foregroundColor(titleColor.light)
                                .position(x:baseScale * 4, y: baseScale * 2.8)
                            RegularPolygon(vertexNumber: 6)
                                .foregroundColor(.gray)
                                .frame(width:baseScale * 0.8, height:baseScale * 0.8)
                                .position(x: baseScale * 4, y: baseScale * 0.5)
                        }
                        //右側
                        TriangleNormalShape()
                            .foregroundColor(.gray)
                            .frame(width: baseScale * sqrt(3), height: baseScale *
                                   1.5 )
                            .position(x: baseScale * 7, y: baseScale * 2)
                        //左側の三角形
                        TriangleNormalShape()
                            .foregroundColor(.backgroundLightGray)
                            .rotationEffect(Angle(degrees: 180))
                            .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                            .position(x: baseScale * 1, y: baseScale * 1.8)
                    }
                    .frame(height: proxy.size.width * 0.5)
                    .padding()
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


