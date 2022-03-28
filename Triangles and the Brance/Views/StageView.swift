//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var game:GameModel
    let backGround = StaticStageObjects()
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack {
                        Text("stage")
                            .font(.title)
                            .foregroundColor(Color(white: 0.3))
                        Rectangle()
                            .frame(width: 40, height: 40, alignment: .center)
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(game.currentColor.light)
                            .overlay{
                                Rectangle()
                                    .stroke(game.currentColor.heavy)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .rotationEffect(Angle(degrees: 45))
                            }
                            .overlay{
                                Text(String(game.stageLevel))
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            Spacer()
                    }
                    Rectangle()
                        .stroke()
                        .frame(width: UIScreen.main.bounds.width*2/3, height: 30 )
                        .padding(.leading, 10)
                }
                ZStack(alignment: .center) {
                    GeometryReader { geometory in
                        //背景
                        DrawShapeFromVertexCoordinate(coordinates: StaticStageObjects.hexagon, scale: geometory.size.width/6)
                            .foregroundColor(.backgroundLightGray)
                        //背景の線部分
                        ForEach(backGround.stageLines){ line in
                            DrawTriLine(line: line, scale: geometory.size.width/6)
                                .stroke(game.currentColor.heavy, lineWidth: 1)
                        }
                        //メインの三角形の表示
                        ForEach(game.triangles){ triangles in
                            TriangleFromCenterView(id: triangles.id, size: geometory.size.width/6)
                        }
                    }.frame(width: UIScreen.main.bounds.width * 7/8, height: UIScreen.main.bounds.width*3/4)
                        .padding(.vertical, 10)
                }
                Section {
                    GeometryReader { geometry in
                        HStack {
                            ActionItemView(item: StaticStageObjects.normalActionItem, size: geometry.size.height)
                                .overlay{
                                    Text("\(String(game.parameters.normalActionCount))")
                                        .foregroundColor(Color(white: 0.4))
                                        .font(.title2)
                                        .position(x: geometry.size.height * 0.5 , y: geometry.size.height + geometry.size.height / 6)
                                }
                                .padding(.leading, geometry.size.height / 4)
                                .padding(.trailing, geometry.size.height / 8)
                            Divider().background(Color(white : 0.1))
                            ForEach(game.actionItems,id: \.self){ item in
                                ActionItemView(item: item,size:geometry.size.height)
                                    .padding(.leading, 30)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/16,alignment: .center)
                .padding(10)
                .background{
                    RectangleWithTwoTextSpace(textSpaceWidth: UIScreen.main.bounds.width/4, textSpaceHeight: UIScreen.main.bounds.width/24)
                        .foregroundColor(Color.backgroundLightGray)
                }
            }
            Section {
                BaranceView()
            }
            .padding(.top, 10)
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(GameModel())
    }
}


