//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    @ObservedObject private var stage = StageModel()
    
    var body: some View {
        GeometryReader{ geometory in
            VStack {
                ZStack{
                    //背景
                    HexagonBackground(length: geometory.size.width/7)
                    //背景の線部分
                    ForEach(stage.stageLines){ line in
                        DrawTriLine(line: line, scale: geometory.size.width/7)
                            .stroke(Color.heavyRed, lineWidth: 1)
                    }
                   
                    ForEach($stage.stageTriangles){ $item in
                        
                        TriangleView(triangle: $item, scale: geometory.size.width/7)
                        
                    }
                    ForEach($stage.stageTriangles){ $item in

                        TriangleViewFrame(triangle: $item,  scale: geometory.size.width/7)

                    }
                    
                }
                
                ScrollView {
                    HStack {
                        Circle()
                            .foregroundColor(stage.currentColor.color)
                            .frame(width: geometory.size.height/12, height: geometory.size.height/12, alignment: .leading)
                            .padding(.leading,50)
                        
                    }
                    .frame(width: geometory.size.width, height: geometory.size.height/10, alignment: .leading)
                    
                }
            }
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
    }
}


