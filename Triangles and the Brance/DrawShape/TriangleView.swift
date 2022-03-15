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
    var frameOffset: CGFloat{
        switch stage.stageTriangles[index].status{
        case .isOn:
            return 0.95
        case .isDisappearing:
            return 0.95
        case .isOff:
            return 1.6
        }
    }
    var frameOpacity:Double{
        switch stage.stageTriangles[index].status{
        case .isOn:
           return 1
        case .isDisappearing:
          return  1
        case .isOff:
          return  0
        }
    }
    ///フレーム部分の描画
    var frameOfTriangle:some View{
        DrawTriShape(in: stage.stageTriangles[index].vertexCoordinate, scale: scale, offset:frameOffset)
            .stroke(Color.heavyRed, lineWidth: 2)
            .animation(.easeOut(duration: 0.5), value: frameOffset)
            .opacity(frameOpacity)
            .animation(.easeOut(duration: 0.5), value: frameOpacity)
            
    }
    
    var body:some View{
        GeometryReader{ geometry in

        
            DrawTriShape(in: stage.stageTriangles[index].vertexCoordinate ,scale: scale, offset: offset)
              
                .animation(.easeOut(duration: 0.5), value: offset)
                .foregroundColor(.lightRed)
                .opacity(opacity)
                .animation(.easeIn(duration: 0.5), value: opacity)
                .overlay(frameOfTriangle)
            
                .onTapGesture {
                    stage.deleteTrianglesInput(index: index)
                }
        }
//
//        }
//        .onPreferenceChange(TrianglePreferenceKey.self){ newHitBox in
//            stage.stageTriangles[index].hitBox = newHitBox
//        }
    }
}

///GeometryReaderで内側の大きさを読み取るためにPreferenceKeyを設定する構造体
struct TrianglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue()
    }
}

//
/////アニメーション、アクション、描画を設定をする構造体のフレーム部分
//struct TriangleViewFrame:View{
//    @Binding var triangle:TriangleViewModel
//    var scale:CGFloat
//
//    //フレームのViewにアニメーションをつけるプロパティ
//    var frameOffset: CGFloat{
//        switch triangle.status{
//
//        case .isOn:
//            return 0.95
//        case .isDisappearing:
//            return 0.95
//        case .isOff:
//            return 1.6
//        }
//    }
//
//    var frameOpacity:Double{
//        switch triangle.status{
//
//        case .isOn:
//           return 1
//        case .isDisappearing:
//          return  1
//        case .isOff:
//          return  0
//        }
//    }
//
//    var body:some View{
//        DrawTriShape(in: triangle.vertexCoordinate, scale: scale, offset:frameOffset)
//            .stroke(Color.heavyRed, lineWidth: 2)
//            .animation(.easeOut(duration: 0.5), value: frameOffset)
//            .opacity(frameOpacity)
//            .animation(.easeOut(duration: 0.5), value: frameOpacity)
//
//    }
//
//}
//
//
