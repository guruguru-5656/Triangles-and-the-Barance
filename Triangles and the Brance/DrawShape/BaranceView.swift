//
//  BaranceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import SwiftUI

struct BaranceView: View {
    let baseScale = UIScreen.main.bounds.width/12
    @State var opacity = 0.5
    @State var angle:Double
    
    var distance:Double{
        baseScale * 4 * sin(angle)
    }
    
    
    var body: some View {
        ZStack{
            //垂れ下がっている部分
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: baseScale/8, height: baseScale * 1.9)
                .position(x: baseScale * 0.25, y: baseScale * 1 - distance)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: baseScale/8, height: baseScale * 1.9)
                .position(x: baseScale*7.75, y: baseScale * 1 + distance)
            
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.lightGray)
                .frame(width: baseScale * 8, height: baseScale/4)
                .rotationEffect(Angle(radians: angle))
                .position(x: baseScale * 4, y: baseScale/8)
                
            Rectangle()
                .foregroundColor(.lightGray)
                .frame(width: baseScale/4, height: baseScale * 3)
                .position(x: baseScale*4, y: baseScale * 1.5)
            
            //中央の三角形
            DragItemNormalShape()
                .frame(width: baseScale * 2, height: baseScale * sqrt(3))
                .foregroundColor(Color.lightRed)
                .position(x:baseScale * 4, y: baseScale * 2.7)
            Circle()
                .foregroundColor(.gray)
                .frame(width:baseScale/1.5, height:baseScale/1.5)
                .position(x: baseScale * 4, y: baseScale / 6)
            Circle()
                .foregroundColor(.white)
                .frame(width:baseScale/3, height:baseScale/3)
                .position(x: baseScale * 4, y: baseScale / 6)
         
            //右側の円
            Circle()
                .foregroundColor(.gray)
                .frame(width:baseScale * 1.2, height:baseScale * 1.2 )
                .position(x: baseScale * 7.75, y: baseScale * 1.8 + distance)
            
            //左側の三角形の本体
            DragItemNormalShape()
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                .overlay{
                    DragItemNormalShape()
                        .foregroundColor(.heavyRed)
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                        .opacity(0.5)
                }
            
            //三角形のフレーム部分
            DragItemNormalShape()
                .stroke(Color.heavyRed)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                
        }.frame(width: baseScale * 8, height: baseScale * 4)
    }
}

struct BaranceView_Previews: PreviewProvider {
    static var previews: some View {
        BaranceView(angle:Double.pi/15)
    }
}
