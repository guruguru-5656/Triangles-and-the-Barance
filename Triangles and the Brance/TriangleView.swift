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
    @State var offset: CGFloat = 3
    
    var coordinate:TriCoordinate
    var length:CGFloat
    
    var indexOfStage: Int{
        stage.getIndexOfStage(coordinate)!
    }
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
    var backgroundCoordinates:[CGPoint]{
        //後ろの三角用のレイヤー、offsetを固定値で上書き
        let coordinates:[CGPoint]
        let offset = 3.0
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
    
    
    var body:some View{
        ZStack{
            
            //背景レイヤー
            Path{ path in
                path.addLines(backgroundCoordinates)
            }
            .fill(.white)
            
            
            if stage.triangles[indexOfStage].isOn{
                TriangleViewChild(offset: offset, coordinate: coordinate, length: length)
                .fill(stage.currentColor.color)
                .transition(.opacity)
                .onTapGesture {
                    withAnimation{
                    stage.tapped(stage.triangles[indexOfStage])
                        offset = -30
                    }
                }
               
               
            }
        }
    }
}

struct TriangleViewChild:Shape,TriCoodinatable{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.addLines(coordinates)
        }
    }
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
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
