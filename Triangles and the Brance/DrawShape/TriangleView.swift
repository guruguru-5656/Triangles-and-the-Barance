//
//  TriangleModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import Foundation
import SwiftUI

///アニメーション、アクション、描画を設定をする構造体
struct TriangleView:View{
    @EnvironmentObject var stage:StageModel
    let coordinate:ModelCoordinate
    var index:Int{
        stage.stageTriangles.firstIndex{ $0.modelCoordinate == self.coordinate }!
    }
    ///拡大率のプロパティ
    var scale:CGFloat
    
    
    //Viewにアニメーションをつけるプロパティ
    var offset: CGFloat{
 
        switch stage.stageTriangles[index].status{
            
        case .isOn:
           return 0.95
        case .isDisappearing:
           return 0.95
        case .isOff:
           return 1.1
        }
    }
    var opacity:Double{

        switch stage.stageTriangles[index].status{
            
        case .isOn:
           return 1
        case .isDisappearing:
           return 1
        case .isOff:
           return 0
        }
    }

    var body:some View{
        DrawTriShape(in: stage.stageTriangles[index].vertexCoordinate ,scale: scale, offset: offset)
            .animation(.easeOut(duration: 0.5), value: offset)
            .foregroundColor(.lightRed)
            .opacity(opacity)
            .animation(.easeIn(duration: 0.5), value: opacity)
            .onTapGesture {
                stage.deleteTrianglesInput(index: index)
            }
    }
}

///アニメーション、アクション、描画を設定をする構造体のフレーム部分
struct TriangleViewFrame:View{
    @Binding var triangle:TriangleViewModel
    var scale:CGFloat
    
    //Viewにアニメーションをつけるプロパティ
    var offset: CGFloat{
        switch triangle.status{
            
        case .isOn:
            return 0.95
        case .isDisappearing:
            return 0.95
        case .isOff:
            return 1.6
        }
    }
    
    var opacity:Double{
        switch triangle.status{
            
        case .isOn:
           return 1
        case .isDisappearing:
          return  1
        case .isOff:
          return  0
        }
    }
    
    var body:some View{
        DrawTriShape(in: triangle.vertexCoordinate, scale: scale, offset:offset)
            .stroke(Color.heavyRed, lineWidth: 2)
            .animation(.easeOut(duration: 0.5), value: offset)
            .opacity(opacity)
            .animation(.easeOut(duration: 0.5), value: opacity)
            
    }
    
}


