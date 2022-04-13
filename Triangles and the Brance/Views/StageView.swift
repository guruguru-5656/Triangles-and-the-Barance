//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var gameModel: GameModel
    @State var backGround = StaticStageObjects()
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Section {
                    Text(String(gameModel.parameter.life))
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 35.0, weight: .regular)))
                        .foregroundColor(gameModel.parameter.life <= 1 ? Color.red : Color(white: 0.3))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Rectangle()
                                        .stroke()
                                        .foregroundColor(gameModel.currentColor.heavy)
                                        .background(Color.backgroundLightGray.scaleEffect(1.2))
                                        .frame(width: gameModel.screenBounds.width * 0.1, height: gameModel.screenBounds.width * 0.1)
                                        .rotationEffect(Angle(degrees: 45))
                        )
                        .padding(.top, 10)
                }
                .padding(.horizontal, gameModel.screenBounds.width * 0.07)
                Spacer()
                HStack(alignment: .center) {
                    Text("stage")
                        .font(.title)
                        .foregroundColor(Color(white: 0.3))
                    
                    Text(String(gameModel.parameter.level))
                        .font(.largeTitle)
                        .foregroundColor(gameModel.currentColor.light)
                }
                Spacer()
                Button(action: {}){
                    Image(systemName: "gearshape")
                        .foregroundColor(Color(white: 0.3))
                        .scaleEffect(1.5)
                        .frame(width: gameModel.screenBounds.width * 0.1, height: gameModel.screenBounds.width * 0.1)
                        .padding(.trailing, gameModel.screenBounds.width * 0.05)
                        .padding(.leading, gameModel.screenBounds.width * 0.1)
                }
            }
            .frame(width: gameModel.screenBounds.width,
                   height: gameModel.screenBounds.height/32)
            .padding(.top, 15)
            .padding(.bottom, 40)
            ZStack(alignment: .center) {
                GeometryReader { geometory in
                    //背景
                    DrawShapeFromVertexCoordinate(coordinates: StaticStageObjects.hexagon, scale: geometory.size.width/6)
                        .foregroundColor(.backgroundLightGray)
                        .scaleEffect(1.05)
                    //背景の線部分
                    ForEach(backGround.stageLines){ line in
                        DrawTriLine(line: line, scale: geometory.size.width/6)
                            .stroke(gameModel.currentColor.heavy, lineWidth: 1)
                    }
                    //メインの三角形の表示
                    ForEach(gameModel.triangles){ triangles in
                        TriangleFromCenterView(id: triangles.id, size: geometory.size.width/6)
                    }
                }.frame(width: gameModel.screenBounds.width * 7/8, height: gameModel.screenBounds.width*3/4)
                    .padding(.vertical, 10)
            }
            Section {
                GeometryReader { geometry in
                    HStack {
                        ActionItemView(item: StaticStageObjects.normalActionItem, size: geometry.size.height)
                            .overlay{
                                Text("\(String(gameModel.parameter.normalActionCount))")
                                    .foregroundColor(Color(white: 0.4))
                                    .font(.title2)
                                    .position(x: geometry.size.height * 0.5 , y: geometry.size.height + geometry.size.height / 6)
                            }
                            .padding(.leading, geometry.size.height / 4)
                            .padding(.trailing, geometry.size.height / 8)
                        Divider().background(Color(white : 0.1))
                        ForEach(gameModel.actionItems,id: \.self){ item in
                            ActionItemView(item: item,size:geometry.size.height)
                                .padding(.leading, 15)
                        }
                    }
                }
            }
            .frame(width: gameModel.screenBounds.width, height: gameModel.screenBounds.height/16)
            .padding(10)
            .background{
                RectangleWithTwoTextSpace(textSpaceWidth: gameModel.screenBounds.width/4, textSpaceHeight: gameModel.screenBounds.width/24)
                    .foregroundColor(Color.backgroundLightGray)
            }
            BaranceView()
                .padding(.top, 10)
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(GameModel.shared)
    }
}


