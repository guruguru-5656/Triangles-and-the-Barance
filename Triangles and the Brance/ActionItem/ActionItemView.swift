//
//  DragNormalItemView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///アイテムのビュー
struct ActionItemView: View {
    @EnvironmentObject var stage:StageModel

    let item:ActionItemModel
    let size:CGFloat
    
    //アニメーション用プロパティ
    var circleScale:Double{
        guard let stageItem = stage.selectedActionItem
        else{ return 2 }
        if stageItem.id == self.item.id {
            return 1
        }else{
            return 2
        }
    }
    var circleOpacity:Double{
        guard let stageItem = stage.selectedActionItem
        else{ return 0 }
        if stageItem.id == self.item.id{
            return 1
        }else{
            return 0
        }
    }
   //ステージのインデックスを取得する
    var index:Int{
        return stage.actionItems.firstIndex{ $0.id == self.item.id }!
    }
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color.lightRed, lineWidth: 1)
                .frame(width: size, height: size, alignment: .center)
                .scaleEffect(circleScale)
                .animation(Animation.easeOut(duration: 0.2),value:circleScale)
                .opacity(circleOpacity)
                .animation(Animation.easeOut(duration: 0.2),value:circleOpacity)
                .contentShape(Circle())
                .onTapGesture{
                    if stage.selectedActionItem == nil{
                        stage.selectedActionItem = item
    
                    }else{
                        stage.selectedActionItem = nil
                    }
                }
        
                TriforceActionView(size: size)
            
        }
        .frame(width: size, height: size * sqrt(3)/2, alignment: .center)
        .padding(.leading, 30)
    }
}


struct TriforceActionView:View{
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
