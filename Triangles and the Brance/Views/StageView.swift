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
            VStack(alignment: .leading, spacing: 10) {
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
                    Button(action: {}){
                        Image(systemName: "gearshape")
                            .foregroundColor(Color(white: 0.3))
                            .scaleEffect(1.5)
                            .frame(width: viewEnvironment.screenBounds.width * 0.1, height: viewEnvironment.screenBounds.width * 0.1)
                            .padding(.trailing, viewEnvironment.screenBounds.width * 0.05)
                            .padding(.leading, viewEnvironment.screenBounds.width * 0.1)
                    }
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
                ActionItemAllOverView(size: geometry.size.width)

                BaranceView()
                    .padding(.top, 10)
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


