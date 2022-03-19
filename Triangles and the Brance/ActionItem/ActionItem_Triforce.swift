//
//  ActionItem_Triforce.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/18.
//

import SwiftUI


struct TriforceActionView:DrawItemActionView{
    let size:CGFloat
    
    var body: some View {
        ZStack{
    DragItemNormalShape()
              .stroke(Color.lightRed, lineWidth: 2)
              .overlay(DragItemNormalShape()
                          .fill(Color.white)
                          .opacity(0.7)
              )
              .frame(width: size, height: size, alignment: .top)
  
              DragItemNormalShapeSmall()
                   .stroke(Color.lightRed, lineWidth: 2)
                   .frame(width: size, height: size, alignment: .top)
        }
        
    }
}

struct DragItemNormalShapeSmall: Shape{

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


struct DragItemNormalShape:Shape{

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

