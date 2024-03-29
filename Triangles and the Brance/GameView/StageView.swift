//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var gameModel: GameModel
    @Binding var isShowPopup: Bool
    private let soundPlayer = SEPlayer.shared
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    ZStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.backgroundLightGray)
                            VStack {
                                Text("turn")
                                    .font(.smartFontUI(.body))
                                    .foregroundColor(Color.backgroundLightGray)
                                    .frame(width: geometry.size.width * 0.15)
                                    .background(Color.gray)
                                Spacer()
                            }
                        }
                        .rotationEffect(Angle(degrees: -45))
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                        Text(String(gameModel.stageStatus.life))
                            .font(Font(UIFont.monospacedSystemFont(ofSize: geometry.size.width * 0.08, weight: .regular)))
                            .foregroundColor(gameModel.stageStatus.life <= 1 ? Color.red : Color(white: 0.3))
                            .offset(x: geometry.size.width * 0.015, y:  geometry.size.width * 0.015)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    Spacer()
                    HStack(alignment: .center) {
                        Text("STAGE")
                            .font(.smartFontUI(.largeTitle))
                            .foregroundColor(Color(white: 0.3))
                        Text(String(gameModel.stageStatus.stage))
                            .font(.smartFontUI(.largeTitle))
                            .scaleEffect(1.1)
                            .foregroundColor(gameModel.currentColor.light)
                            .padding(5)
                    }
                    .offset(x: geometry.size.width * -0.03)
                    Spacer()
                    Button(action: {
                        soundPlayer.play(sound: .selectSound)
                        isShowPopup.toggle()
                    }){
                        VStack {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .scaledToFit()
                            Text("MENU")
                                .font(.smartFontUI(.caption))
                        }
                        .foregroundColor(.backgroundLightGray)
                        .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                    }
                }
                .padding(.horizontal, geometry.size.width / 16)
                Spacer()
                TriangleView()
                    .padding(.horizontal, geometry.size.width / 10)
                    .frame(height: geometry.size.width * 0.7)
                Spacer()
                ActionItemContainerView()
                    .frame(height: geometry.size.width * 0.33)
                    .zIndex(1)
                Spacer()
                BaranceView()
                    .padding(.horizontal, geometry.size.width * 0.1)
                    .frame(height: geometry.size.width * 0.35)
            }
        }
    }
}

struct StageView_Previews: PreviewProvider {
    @State static private var isShowPopup = false
    static var previews: some View {
        StageView(isShowPopup: $isShowPopup)
            .environmentObject(GameModel())
    }
}


