//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var stage:GameModel
   let backGround = StageBackground()
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack {
                        Text("level")
                            .font(.title)
                            .foregroundColor(Color(white: 0.3))
                        Rectangle()
                            .frame(width: 50, height: 50, alignment: .center)
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(stage.currentColor.light)
                            .overlay{
                                Rectangle()
                                    .stroke(stage.currentColor.heavy)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .rotationEffect(Angle(degrees: 45))
                            }
                            .overlay{
                                Text(String(stage.stageLevel))
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                    }
                    .padding(30)
                }
                ZStack(alignment: .center) {
                    GeometryReader { geometory in
                        //背景
                        DrawShapeFromVertexCoordinate(coordinates: StageBackground.hexagon, scale: geometory.size.width/6)
                            .foregroundColor(.backgroundLightGray)
                        //背景の線部分
                        ForEach(backGround.stageLines){ line in
                            DrawTriLine(line: line, scale: geometory.size.width/6)
                                .stroke(stage.currentColor.heavy, lineWidth: 1)
                        }
                        //メインの三角形の表示
                        ForEach(stage.triangles){ triangles in
                            TriangleFromCenterView(id: triangles.id, size: geometory.size.width/6)
                        }
                    }.frame(width: UIScreen.main.bounds.width * 7/8, height: UIScreen.main.bounds.width*3/4)
                        .padding(.vertical, 10)
                }
                Section {
                    GeometryReader { geometry in
                    HStack {
                            ForEach(stage.actionItems,id: \.self){ item in
                                ActionItemView(item: item,size:geometry.size.height)
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/12,alignment: .center)
                .padding(.top, 10)
                
                .background(Color.lightGray)
            }
            HStack {
                GeometryReader { geometry in
                    VStack {
                        TriangleNormalShape()
                            .fill(stage.currentColor.heavy)
                            .frame(width: 80, height: 80)
                            .padding(.top, 30)
                            .padding(.leading, 15)
                        Text("×\(String(stage.life))")
                            .font(.title)
                            .foregroundColor(Color(white: 0.3))
                            .position(x: geometry.size.width/2 + 7, y: -10)
                    }
                }
                BaranceView()
                    .padding(30)
            }
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(GameModel())
    }
}


