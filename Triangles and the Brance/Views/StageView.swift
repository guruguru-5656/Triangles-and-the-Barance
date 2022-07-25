//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @StateObject var stageModel = GameModel.shared.stageModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Section {
                        Text(String(stageModel.life))
                            .font(Font(UIFont.monospacedSystemFont(ofSize: 35.0, weight: .regular)))
                            .foregroundColor(stageModel.life <= 1 ? Color.red : Color(white: 0.3))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(
                                Rectangle()
                                    .stroke()
                                    .foregroundColor(viewEnvironment.currentColor.heavy)
                                    .background(Color.backgroundLightGray.scaleEffect(1.2))
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                    .rotationEffect(Angle(degrees: 45)))
                    }
                    Spacer()
                    HStack(alignment: .center) {
                        Text("stage")
                            .font(.largeTitle)
                            .foregroundColor(Color(white: 0.3))
                        
                        Text(String(stageModel.level))
                            .font(.largeTitle)
                            .foregroundColor(viewEnvironment.currentColor.light)
                    }
                    Spacer()
                    Button(action: {
                        GameModel.shared.gameOver()
                    }){
                        Image(systemName: "flag.fill")
                            .resizable()
                            .foregroundColor(.backgroundLightGray)
                            .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                    }
                }
                .frame(alignment: .center)
                .padding(.horizontal, geometry.size.width / 16)
                Spacer()
                Section {
                    TriangleView()
                                     .padding(.horizontal, geometry.size.width / 10)
                    //MARK: 現状エフェクトviewは未使用
//                    ActionEffectView(size: geometry.size.width / 6)
                }
                .frame(width: geometry.size.width ,height: geometry.size.width * 0.75)
//                .background(.purple)
                Spacer()
                ActionItemWholeView(size: geometry.size.width)
                    .frame( height: geometry.size.width * 0.22)
                    .background(.purple)
                Spacer()
                Section {
                GeometryReader { geometry in
                    BaranceView(size: geometry.size.width)
                }
                .padding(.horizontal, geometry.size.width * 0.1)
                }
                .frame( height: geometry.size.width * 0.35)
                Spacer()
            }
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}


