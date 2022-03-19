//
//  ActionItem_TriforceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import SwiftUI

struct ActionItem_TriforceView: View {
    @EnvironmentObject var stage:StageModel
    @State var opacity:Double = 0
    @State var scale:Double = 0.3
    let width:CGFloat
    let height:CGFloat
    let rotation:Angle
    let drawPoint:CGPoint
    
    var body: some View {
        DrawTriangleFromCenter()
            .stroke(Color.heavyRed, lineWidth: 3)
            .frame(width: width, height: height, alignment: .top)
            .rotationEffect(rotation)
            .scaleEffect(scale)
            .position(drawPoint)
            .opacity(opacity)
            .onAppear{
                withAnimation(Animation.easeOut(duration: 0.3)){
                    opacity = 1
                    scale = 0.475
                }
            }
            .onDisappear{
                withAnimation(Animation.timingCurve(0.9, 0, 0.95, 0.9, duration: 0.6)){
                    opacity = 0
                }
                withAnimation(Animation.easeOut(duration: 0.6)){
                    scale = 1.9
                }
            }
    }
}
