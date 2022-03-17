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
            ProgressView(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/)
                .tint(.heavyRed)
                .frame(width: UIScreen.main.bounds.width, height: 30, alignment: .center)
                .padding(.vertical, 60)
    
            VStack {
            
                ZStack{
                    GeometryReader{ geometory in
                        
                        //背景
                        HexagonBackground(length: geometory.size.width/7)
                        //背景の線部分
                        ForEach(stage.stageLines){ line in
                            DrawTriLine(line: line, scale: geometory.size.width/7)
                                .stroke(Color.heavyRed, lineWidth: 1)
                        }
                        
                        ForEach($stage.stageTriangles){ $triangles in
                            TriangleFromCenterView(model: triangles, size: geometory.size.width/7)
//                            TriangleView(coordinate: triangles.modelCoordinate, scale: geometory.size.width/7)
                            
                        }
                    }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .padding(.vertical, 10)
                    
                }
                
     
                HStack(alignment:.center){
                    GeometryReader{ geometry in
                        ForEach(stage.stageActionItems){ item in
                            ActionItemView(item: item,size:geometry.size.height)
                        }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/12,alignment: .center)
                .padding(.top, 10)
                
                .background(Color.lightGray)
            }
        }
        Spacer()
    }
}


struct HexagonBackground:View{
    let length:CGFloat
    private let offset:CGFloat = 3
    private var offsetA:CGFloat{
        offset * 1/sqrt(3)
    }
    var vertex:[CGPoint]{
        [CGPoint(x: 2 * length - offsetA, y: 0 - offset),
         CGPoint(x: 5 * length + offsetA, y: 0 - offset),
         CGPoint(x: 6.5 * length + offset , y: 3 * sqrt(3)/2 * length),
         CGPoint(x: 5 * length + offsetA , y: 6 * sqrt(3)/2 * length + offset),
         CGPoint(x: 2 * length - offsetA, y: 6 * sqrt(3)/2 * length + offset),
         CGPoint(x: 0.5 * length - offset, y: 3 * sqrt(3)/2 * length),
         CGPoint(x: 2 * length - offsetA, y: 0 - offset)]
    }
    var body:some View{
        Path{ path in
            path.addLines(vertex)
        }
        .fill()
        .foregroundColor(.backgroundLightGray)
    }
}



struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(StageModel.setUp)
    }
}


