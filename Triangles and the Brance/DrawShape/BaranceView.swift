//
//  BaranceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import SwiftUI

struct BaranceView: View {
    let baseScale = UIScreen.main.bounds.width/14
    @EnvironmentObject var game:GameModel
    var opacity:Double{
        game.clearPercent
    }
    var angle:Double{
        (0.5 - Double(game.clearPercent)) * Double.pi/12
    }
    
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
                .animation(.default, value: distance)
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: baseScale/8, height: baseScale * 1.9)
                .position(x: baseScale*7.75, y: baseScale * 1 + distance)
                .animation(.default, value: distance)
            
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.lightGray)
                .frame(width: baseScale * 8, height: baseScale/4)
                .rotationEffect(Angle(radians: angle))
                .animation(.default, value: angle)
                .position(x: baseScale * 4, y: baseScale/8)
                
            Rectangle()
                .foregroundColor(.lightGray)
                .frame(width: baseScale/4, height: baseScale * 3)
                .position(x: baseScale*4, y: baseScale * 1.5)
            
            //中央の三角形
            TriangleNormalShape()
                .frame(width: baseScale * 2, height: baseScale * sqrt(3))
                .foregroundColor(game.currentColor.light)
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
                .animation(.default, value: distance)
            Group{
            //左側の三角形の本体
            TriangleNormalShape()
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                .animation(.default, value: distance)
                .overlay{
                    TriangleNormalShape()
                        .foregroundColor(game.currentColor.heavy)
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                        .animation(.default, value: distance)
                        .opacity(opacity)
                        .animation(.default, value: opacity)
                }
            //三角形のフレーム部分
            TriangleNormalShape()
                .stroke(game.currentColor.heavy)
                .rotationEffect(Angle(degrees: 180))
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                .animation(.default, value: distance)
        }.frame(width: baseScale * 8, height: baseScale * 4)
        }
    }
}

struct BaranceView_Previews: PreviewProvider {
    static var previews: some View {
        BaranceView()
            .environmentObject(GameModel())
    }
}
