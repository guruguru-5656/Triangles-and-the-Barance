//
//  DragNormalItemView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI
///ドラッグするアイテム
struct DragItemView: View {
    @EnvironmentObject var stage:StageModel
    @State var isDragging = false
//    @State var posision:CGPoint
    let size:CGFloat
    let id:UUID
    var index:Int{
       return stage.stageDragItems.firstIndex{ $0.id == self.id }!
    }
    var rotate:Angle{
//        guard let index = index else {
//            return Angle(degrees: 0)
//        }
        return stage.stageDragItems[index].isRotated ? Angle(degrees: 0) : Angle(degrees: 180)
    }

    
    var drag: some Gesture {
        DragGesture()
//            .onChanged { gesture in
//                self.posision = gesture.
//                self.isDragging = true
//            }
            .onEnded { _ in self.isDragging = false }
        
    }
    
    
    var body: some View {
        DragItemNormalShape()
            .fill(Color.lightRed)
            .frame(width: size, height: size*sqrt(3)/2, alignment: .leading)
            .rotationEffect(rotate)
            .animation(.default, value: rotate)
//            .onDrag{
//                NSItemProvider(object: stage.stageDragItems[index].type
//            }
//            .position(x: posision.x, y: posision.y)
            
            .padding(.horizontal, 50)
    }
}

struct DragItemNormalShape:Shape{

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        path.addLine(to:CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        return path
    }
}
