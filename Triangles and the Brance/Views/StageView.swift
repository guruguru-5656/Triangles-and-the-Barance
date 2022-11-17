//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var stageModel: StageModel
    
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
                                    .foregroundColor(stageModel.currentColor.heavy)
                                    .background(Color.backgroundLightGray.scaleEffect(1.2))
                                    .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                    .rotationEffect(Angle(degrees: 45)))
                    }
                    Spacer()
                    HStack(alignment: .center) {
                        Text("stage")
                            .font(.largeTitle)
                            .foregroundColor(Color(white: 0.3))
                        
                        Text(String(stageModel.stage))
                            .font(.largeTitle)
                            .foregroundColor(stageModel.currentColor.light)
                    }
                    Spacer()
                    Button(action: {
                        stageModel.giveUp()
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
                }
                .frame(width: geometry.size.width ,height: geometry.size.width * 0.75)
                Spacer()
                ActionItemWholeView(size: geometry.size.width)
                    .frame( height: geometry.size.width * 0.22)
                    .zIndex(1)
                Spacer()
                BaranceView()
                    .padding(.horizontal, geometry.size.width * 0.1)
                    .frame( height: geometry.size.width * 0.35)
                Spacer()
            }
        }
        .onAppear {
            stageModel.startBgm()
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(StageModel())
    }
}


