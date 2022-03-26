//
//  ActionItem_TriforceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import SwiftUI

struct ActionItem_TriforceView: View {
    @EnvironmentObject var stage:GameModel
    @State var opacity:Double = 1
    @State var scale:Double = 0.5
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
                    opacity = 1
                    scale = 0.475
            }
            .onDisappear{
                    opacity = 0
                    scale = 1.9
            }
    }
}
