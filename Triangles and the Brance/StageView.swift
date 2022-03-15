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
            ZStack{
                GeometryReader{ geometory in
                    
                    //背景
                    HexagonBackground(length: geometory.size.width/7)
                    //背景の線部分
                    ForEach(stage.stageLines){ line in
                        DrawTriLine(line: line, scale: geometory.size.width/7)
                            .stroke(Color.heavyRed, lineWidth: 1)
                    }
                    
                    ForEach(stage.stageTriangles){ triangles in
                        
                        TriangleView(coordinate: triangles.modelCoordinate,scale: geometory.size.width/7)
                        
                    }
                }
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*3/4)
            .padding(.vertical)
            
            HStack {
                GeometryReader{ geometory in
                    ForEach(stage.stageDragItems){ item in
                        DragItemView(size: geometory.size.height, id: item.id)
                            
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/14)
            .padding(.vertical)
            
        }
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


