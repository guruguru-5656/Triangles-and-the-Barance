//
//  ActionItem_Triforce.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/18.
//

import SwiftUI


struct NormalActionView: View{
    
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @ObservedObject var itemController = GameModel.shared.itemController
    let size: CGFloat
    var body: some View {
        TriangleNormalShape()
            .fill(viewEnvironment.currentColor.light)
            .overlay {
                TriangleNormalShape()
                    .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
            }
            .frame(width: size, height: size)
    }
}

struct PyramidItemView: View{
    
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let size:CGFloat
    var body: some View {
        ZStack{
            TriangleNormalShape()
                .fill(viewEnvironment.currentColor.light)
            TriangleNormalShape()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
            TriangleNormalShape()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.5)
                .rotationEffect(Angle(degrees: 180))
        }
        .frame(width: size, height: size)
    }
}

struct TriangleNormalShape:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        path.addLine(to:CGPoint(x: rect.width * (2-sqrt(3))/4 , y: rect.height * 3/4))
        path.addLine(to: CGPoint(x: rect.width * (2+sqrt(3))/4, y: rect.height * 3/4))
        path.addLine(to: CGPoint(x: rect.width/2, y: 0))
        path.closeSubpath()
        return path
    }
}

