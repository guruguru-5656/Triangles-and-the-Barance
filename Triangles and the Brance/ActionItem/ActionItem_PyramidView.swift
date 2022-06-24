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
            .frame(width: size, height: size)
            .opacity(itemController.normalActionCount == 0 ? 0.5 : 1)
            .animation(.default, value: itemController.normalActionCount)
            .overlay {
                Text("\(itemController.normalActionCount)")
                    .offset(x: 0, y: size * 2/3)
                    .font(Font(UIFont.monospacedSystemFont(ofSize: size * 2/5, weight: .regular)))
                    .foregroundColor(itemController.normalActionCount == 0 ? .red : .black)
            }
    }
}

struct PyramidItemView: View{
    
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let size:CGFloat
    var body: some View {
        ZStack{
            TriangleNormalShape()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 3)
                .overlay(TriangleNormalShape()
                            .fill(viewEnvironment.currentColor.light)
                )
                
            TriangleNormalShapeSmall()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
                .scaleEffect(0.8)
                
            TriangleNormalShapeSmall()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
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

