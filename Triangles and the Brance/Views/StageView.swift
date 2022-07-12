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
            VStack(alignment: .center, spacing: 20) {
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
                                    .frame(width: viewEnvironment.screenBounds.width * 0.1, height: viewEnvironment.screenBounds.width * 0.1)
                                    .rotationEffect(Angle(degrees: 45)))
                    }
                    Spacer()
                    HStack(alignment: .center) {
                        Text("stage")
                            .font(.title)
                            .foregroundColor(Color(white: 0.3))
                        
                        Text(String(stageModel.level))
                            .font(.largeTitle)
                            .foregroundColor(viewEnvironment.currentColor.light)
                    }
                    Spacer()
                    Text("score")
                    Text("\(stageModel.score)")
                }
                .frame(alignment: .center)
                .padding(.horizontal, geometry.size.width / 16)
                Spacer()
                GeometryReader { geometry in
                    TriangleView(size: geometry.size.width / 6)
                    //MARK: 現状エフェクトviewは未使用
//                    ActionEffectView(size: geometry.size.width / 6)
                }
                .frame(height: geometry.size.width * 1/2 )
                .padding(.top)
                .padding(.horizontal, geometry.size.width / 8)
                .padding(.bottom, geometry.size.width / 8)
                ActionItemWholeView(size: geometry.size.width)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.13)
                BaranceView()
                    .frame( height: geometry.size.height * 0.1)
                    .padding(.vertical, geometry.size.height * 0.1)
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


