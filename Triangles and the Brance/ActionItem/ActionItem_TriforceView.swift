//
//  ActionItem_Triforce.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/18.
//

import SwiftUI


struct NormalActionView: View{
    @EnvironmentObject var game:GameModel
    let size:CGFloat
    var body: some View {
        TriangleNormalShape()
            .fill(game.currentColor.light)
            .frame(width: size, height: size)
            .opacity(game.parameter.normalActionCount == 0 ? 0.5 : 1)
            .animation(.default, value: game.parameter.normalActionCount)
    }
}

struct TriforceActionView: View{
    @EnvironmentObject var game:GameModel
    let size:CGFloat
    var body: some View {
        ZStack{
            TriangleNormalShape()
                .stroke(game.currentColor.heavy, lineWidth: 3)
                .overlay(TriangleNormalShape()
                            .fill(game.currentColor.light)
                )
                
            TriangleNormalShapeSmall()
                .stroke(game.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.8)
                
            TriangleNormalShapeSmall()
                .stroke(game.currentColor.heavy, lineWidth: 2)
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

