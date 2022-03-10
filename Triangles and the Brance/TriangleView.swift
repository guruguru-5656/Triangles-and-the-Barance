//
//  TriangleModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import Foundation
import SwiftUI



struct TriangleView:View, TriCoodinatable,Animatable{
    @ObservedObject var stage:StageModel
    var offset: CGFloat{
        stage.stageTriangles[indexOfStage].isOn ? 3 : -10
    }
    var opacity:Double{
        stage.stageTriangles[indexOfStage].isOn ? 1 : 0
    }
  
    var coordinate:TriCoordinate
    var length:CGFloat
    
    var indexOfStage: Int{
        stage.getIndexOfStage(coordinate)!
    }
    
    var body:some View{
        if stage.stageTriangles[indexOfStage].isOn{
            TriangleViewChild(color:stage.currentColor,opacity:opacity,offset: offset, coordinate: coordinate, length: length)
            .fill(stage.currentColor.color)
            .onTapGesture {
               
                    stage.delete(coordinate: coordinate)
            }
            .transition(
                AnyTransition.animation(Animation.default.)
            )
        }
    }
}

struct TriangleViewChild:View,Animatable,TriCoodinatable{
    var body: some View{
        Path{ path in
            path.addLines(coordinates)
        }
        .fill(color.opacity(opacity))
    }
    //アニメーション用の変数
    var animatableData:AnimatablePair<Double, CGFloat>{
        get { AnimatablePair(offset,opacity) }
        set {
            offset = newValue.first
            opacity = newValue.second
        }
    }
    var color:Color
    var opacity:Double = 1
    var offset: CGFloat
    var coordinate:TriCoordinate
    var length:CGFloat
    
    var coordinates:[CGPoint]{
        let coordinates:[CGPoint]
        let offsetA = offset * sqrt(3)/2 //offset * cos(30[deg])
        let x = CGFloat(coordinate.0)
        let y = CGFloat(coordinate.1)
        let lengthY = length * sqrt(3)/2
        
        //三角形の向きによって計算式を変更
        if coordinate.2{
            coordinates = [CGPoint(x: (x + y/2) * length + offsetA,
                                   y: y * lengthY + offset/2),
                           CGPoint(x: ((x+1) + y/2 ) * length - offsetA,
                                   y: y * lengthY + offset/2),
                           CGPoint(x: (x + (y+1)/2) * length,
                                   y: (y+1) * lengthY - offset),
                           CGPoint(x: (x + y/2) * length + offsetA,
                                   y: y * lengthY + offset/2)]
        }else{
            coordinates = [CGPoint(x: (x + y/2) * length,
                                   y: y * lengthY + offset),
                           CGPoint(x: (x + (y+1)/2) * length - offsetA,
                                   y: (y+1) * lengthY - offset/2),
                           CGPoint(x: ((x-1) + (y+1)/2) * length + offsetA,
                                   y: (y+1) * lengthY - offset/2),
                           CGPoint(x: (x + y/2) * length,
                                   y: y * lengthY + offset),]
        }
        return coordinates
    }
    
}
