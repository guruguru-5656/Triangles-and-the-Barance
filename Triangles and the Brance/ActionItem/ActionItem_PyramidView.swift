//
//  ActionItem_Triforce.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/18.
//

import SwiftUI


struct NormalActionView: View{
    @EnvironmentObject var gameModel:GameModel
    let size:CGFloat
    var body: some View {
        TriangleNormalShape()
            .fill(gameModel.currentColor.light)
            .frame(width: size, height: size)
            .opacity(gameModel.parameter.normalActionCount == 0 ? 0.5 : 1)
            .animation(.default, value: gameModel.parameter.normalActionCount)
    }
}

struct PyramidItemView: View{
    @EnvironmentObject var gameModel:GameModel
    let size:CGFloat
    var body: some View {
        ZStack{
            TriangleNormalShape()
                .stroke(gameModel.currentColor.heavy, lineWidth: 3)
                .overlay(TriangleNormalShape()
                            .fill(gameModel.currentColor.light)
                )
                
            TriangleNormalShapeSmall()
                .stroke(gameModel.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.8)
                
            TriangleNormalShapeSmall()
                .stroke(gameModel.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.8)
                .rotationEffect(Angle(degrees: 180))
        }
        .frame(width: size, height: size)
    }
}

struct TriangleNormalShapeSmall: Shape{    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to:CGPoint(x:rect.width * (4-sqrt(3))/8,y:rect.height * 3/8))
        path.addLine(to: CGPoint(x:rect.width * (4+sqrt(3))/8,y:rect.height * 3/8))
        path.addLine(to: CGPoint(x:rect.width / 2,y:rect.height * 3/4))
        path.addLine(to: CGPoint(x:rect.width * (4-sqrt(3))/8,y:rect.height * 3/8))
        path.closeSubpath()
        return path
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

