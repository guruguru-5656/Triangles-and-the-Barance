//
//  BaranceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import SwiftUI

struct BaranceView: View {
    @EnvironmentObject var gameModel:GameModel
    @ObservedObject var baranceViewContloller = GameModel.shared.baranceViewContloller

    var baseScale: CGFloat {
        GameModel.shared.screenBounds.width/12
    }
    var opacity:Double{
        gameModel.parameter.clearPersent
    }
    var distance:Double{
        baseScale * 4 * sin(baranceViewContloller.angle)
    }
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                //垂れ下がっている部分
                Group{
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
                        .rotationEffect(Angle(radians: baranceViewContloller.angle))
                        .position(x: baseScale * 4, y: baseScale/8)
                    Rectangle()
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale/4, height: baseScale * 3)
                        .position(x: baseScale*4, y: baseScale * 1.5)
                }
                //中央の三角形
                Group{
                    TriangleNormalShape()
                        .frame(width: baseScale * 2, height: baseScale * sqrt(3))
                        .foregroundColor(gameModel.currentColor.light)
                        .position(x:baseScale * 4, y: baseScale * 2.8)
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width:baseScale/1.5, height:baseScale/1.5)
                        .position(x: baseScale * 4, y: baseScale / 6)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width:baseScale/3, height:baseScale/3)
                        .position(x: baseScale * 4, y: baseScale / 6)
                }
                //右側の円
                Group {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width:baseScale * 1.4, height:baseScale * 1.4 )
                        .position(x: baseScale * 7.75, y: baseScale * 1.8 + distance)
                    
                    Text(String(gameModel.parameter.targetDeleteCount))
                        .font(.title2)
                        .foregroundColor(Color(white: 0.1))
                        .position(x: baseScale * 7.75, y: baseScale * 1.8 + distance)
                }
                //左側の三角形の本体
                TriangleNormalShape()
                    .foregroundColor(.backgroundLightGray)
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                    .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                    
                Group {
                    TriangleNormalShape()
                        .foregroundColor(gameModel.currentColor.heavy)
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                    
                    Text(String(gameModel.parameter.deleteCount))
                        .font(.title2)
                        .foregroundColor(Color(white: 0.1))
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                }
                .opacity(opacity)
                if baranceViewContloller.isTriangleHiLighted {
                    TriangleNormalShape()
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 180))
                        .scaleEffect(1.1)
                        .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                        .blur(radius: 5)
                        .opacity(0.5)
                }
                if baranceViewContloller.showDeleteCountText {
                    Text("+\(gameModel.parameter.deleteCountNow)")
                        .font(.title2)
                        .foregroundColor(Color.backgroundLightGray)
                        .position(x: baseScale * 1.5, y: baseScale * 2 - distance)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(x: 0, y: -baseScale * 0.5)),
                            removal: .opacity))
                }
                
                //三角形のフレーム部分
                TriangleNormalShape()
                    .stroke(gameModel.currentColor.heavy)
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                    .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                
                //クリア演出用の円
                if baranceViewContloller.clearCircleIsOn == false {
                    Ellipse()
                        .fill(gameModel.currentColor.light)
                        .frame(width: 30, height: 15)
                        .position(x: baseScale * 0.25, y: baseScale * 3.1)
                    
                    Ellipse()
                        .fill(gameModel.currentColor.heavy)
                        .frame(width: 20, height: 10)
                        .position(x: baseScale * 0.25, y: baseScale * 3.1)
                        .preference(key: ClearCirclePoint.self,
                                    value: CGPoint(
                                        x: geometry.frame(in: .global).origin.x + baseScale * 0.25 + 10,
                                        y: geometry.frame(in: .global).origin.y + baseScale * 3.1))
                    
                }   
            }.frame(width: baseScale * 8, height: baseScale * 4)
                .position(x: baseScale * 6, y: baseScale * 3 )
                
        }
    }
}
