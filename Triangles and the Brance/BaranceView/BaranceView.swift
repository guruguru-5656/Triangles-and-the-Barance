//
//  BaranceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import SwiftUI

struct BaranceView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @ObservedObject var stageModel = GameModel.shared.stageModel
    @ObservedObject var baranceViewContloller = GameModel.shared.baranceViewContloller
    let size: CGFloat
    var baseScale: CGFloat {
        size/8
    }
    var opacity:Double{
        baranceViewContloller.clearPersent
    }
    var distance:Double{
        baseScale * 4 * sin(baranceViewContloller.angle)
    }
    
    var body: some View {
       
            GeometryReader { geometry in
                //左右に伸びる棒
                Group {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: baseScale/8, height: baseScale * 1.5)
                        .position(x: baseScale * 0.25, y: baseScale * 1.25 - distance)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: baseScale/8, height: baseScale * 1.5)
                        .position(x: baseScale*7.75, y: baseScale * 1.25 + distance)
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale * 8, height: baseScale/4)
                        .rotationEffect(Angle(radians: baranceViewContloller.angle))
                        .position(x: baseScale * 4, y: baseScale * 0.5)
                }
                //中央部分
                Group {
                    Rectangle()
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale/4, height: baseScale * 2)
                        .position(x: baseScale*4, y: baseScale * 1.5)
                    TriangleNormalShape()
                        .frame(width: baseScale * 2, height: baseScale * 2 * sqrt(3)/2)
                        .foregroundColor(viewEnvironment.currentColor.light)
                        .position(x:baseScale * 4, y: baseScale * 2.8)
                    RegularPolygon(vertexNumber: 6)
                        .foregroundColor(.gray)
                        .frame(width:baseScale * 0.8, height:baseScale * 0.8)
                        .position(x: baseScale * 4, y: baseScale * 0.5)
                }
                //右側
                TriangleNormalShape()
                    .foregroundColor(.gray)
                    .overlay {
                        Text(String(stageModel.targetDeleteCount))
                            .font(.title2)
                            .foregroundColor(Color(white: 0.1))
                    }
                    .frame(width: baseScale * sqrt(3), height: baseScale *
                           1.5 )
                
                    .position(x: baseScale * 7.75, y: baseScale * 1.8 + distance)
                
                //左側の三角形
                Group {
                    TriangleNormalShape()
                        .foregroundColor(.backgroundLightGray)
                        .rotationEffect(Angle(degrees: 180))
                    TriangleNormalShape()
                        .foregroundColor(viewEnvironment.currentColor.heavy)
                        .rotationEffect(Angle(degrees: 180))
                    
                        .opacity(opacity)
                    Text(String(stageModel.deleteCount))
                        .font(.title2)
                        .foregroundColor(Color(white: 0.1))
                        .opacity((1 + opacity) / 2)
                    if baranceViewContloller.isTriangleHiLighted {
                        TriangleNormalShape()
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 180))
                            .scaleEffect(1.1)
                            .blur(radius: 5)
                            .opacity(0.5)
                    }
                }
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                
                if baranceViewContloller.showDeleteCountText {
                    Text("+\(baranceViewContloller.deleteCountNow)")
                        .font(.title2)
                        .foregroundColor(Color.backgroundLightGray)
                        .position(x: baseScale * 1.5, y: baseScale * 2 - distance)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(x: 0, y: -baseScale * 0.5)),
                            removal: .opacity))
                }
                
                //クリア演出用の円
                if baranceViewContloller.clearCircleIsOn == false {
                    Ellipse()
                        .fill(viewEnvironment.currentColor.light)
                        .frame(width: 30, height: 15)
                        .position(x: baseScale * 0.25, y: baseScale * 3.1)
                    
                    Ellipse()
                        .fill(viewEnvironment.currentColor.heavy)
                        .frame(width: 20, height: 10)
                        .position(x: baseScale * 0.25, y: baseScale * 3.1)
                        .preference(key: ClearCirclePoint.self,
                                    value: CGPoint(
                                        x: geometry.frame(in:.named("contentView") ).origin.x + baseScale * 0.25,
                                        y: geometry.frame(in: .named("contentView")).origin.y + baseScale * 3.1))
                }
            }
    }
}
