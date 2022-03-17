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
//    let action:ActionType
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
    var duration:Double{
        switch stage.stageTriangles[index].status{
        case .isOn:
            return 0.2
        case .isDisappearing:
            return 0.5
        case .isOff:
            return 0.5
        }
    }
   
    ///フレーム部分の描画
    var frameOfTriangle:some View{
        DrawTriShape(at: stage.stageTriangles[index].modelCoordinate, scale: scale, offset:frameOffset,type: stage.stageTriangles[index].action)
            .stroke(Color.heavyRed, lineWidth: 2)
            .animation(.easeOut(duration: duration), value: frameOffset)
            .opacity(opacity)
            .animation(.easeOut(duration: duration), value: opacity)
    }
    var triforceTriangleFrame:some View{
        DrawTriShape(at: stage.stageTriangles[index].modelCoordinate ,scale: scale, offset: offset,type: stage.stageTriangles[index].action)
             .stroke(Color.heavyRed, lineWidth: 2)
            .animation(.easeOut(duration: duration), value: frameOffset)
            .opacity(opacity)
            .animation(.easeOut(duration: duration), value: opacity)
    }
    
    
    var body:some View{
        GeometryReader{ geometry in
            ZStack{
                if stage.stageTriangles[index].action == .triforce{
                   triforceTriangleFrame
                }
            DrawTriShape(at: stage.stageTriangles[index].modelCoordinate ,scale: scale, offset: offset,type: .normal)
                .animation(.easeOut(duration: duration), value: offset)
                .foregroundColor(.lightRed)
                .opacity(opacity)
                .animation(.easeIn(duration: duration), value: opacity)
                .overlay(frameOfTriangle)
                .contentShape(DrawTriShape(at: stage.stageTriangles[index].modelCoordinate ,scale: scale, offset: 1,type: .normal))
                .onTapGesture {
                    if let selectedItem = stage.selectedItem{
                        switch selectedItem.type{
                        case .normal:
                            fallthrough
                        case .triforce:
                            stage.stageTriangles[index].action = .triforce
                        }
                    }else{
                        stage.deleteTrianglesInput(index: index)
                    }
                }
            }
        }
        
    }
}

///GeometryReaderで内側の大きさを読み取るためにPreferenceKeyを設定する構造体
struct TrianglePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect?

    static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
        value = nextValue()
    }
}
