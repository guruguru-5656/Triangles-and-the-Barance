//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @EnvironmentObject var stage:StageModel

    var body: some View {
        
        VStack {
            
            VStack {
                
                ZStack(alignment: .center){
                    GeometryReader{ geometory in
                        
                        //背景
                        DrawShapeFromVertexCoordinate(coordinates: stage.backGroundHexagon, scale: geometory.size.width/6)
                            .foregroundColor(.backgroundLightGray)
                        //背景の線部分
                        ForEach(stage.stageLines){ line in
                            DrawTriLine(line: line, scale: geometory.size.width/6)
                                .stroke(Color.heavyRed, lineWidth: 1)
                        }
                        //メインの三角形の表示
                        ForEach(stage.triangles){ triangles in
                            TriangleFromCenterView(id: triangles.id, size: geometory.size.width/6)
                            
                        }
                    }.frame(width: UIScreen.main.bounds.width * 7/8, height: UIScreen.main.bounds.width*3/4)
                        .padding(.vertical, 10)
                    
                }
                
                Section {
                    GeometryReader{ geometry in
                    HStack{
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
            BaranceView(angle: Double.pi/12)
                .padding(.top, 30)
        }
        
    }
}



struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(StageModel())
    }
}


