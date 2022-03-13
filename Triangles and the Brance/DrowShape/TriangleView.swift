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
    @Binding var triangle:TriangleViewModel
    
    var scale:CGFloat
    //Viewにアニメーションをつけるプロパティ
    var offset: CGFloat{
        triangle.isOn ? 0.95 : 1.1
    }
    var opacity:Double{
        triangle.isOn ? 1 :0
    }

    var body:some View{
        DrawTriShape(in: triangle.vertexCoordinate ,scale: scale, offset: offset)
            .animation(.easeOut(duration: 0.5), value: offset)
            .foregroundColor(.lightRed)
            .opacity(opacity)
            .animation(.easeIn(duration: 0.5), value: opacity)
            .onTapGesture {
                print(triangle.modelCoordinate.x)
                print(triangle.modelCoordinate.y)
                triangle.deleteTriangles()
            }
    }
}

///アニメーション、アクション、描画を設定をする構造体のフレーム部分
struct TriangleViewFrame:View{
    @Binding var triangle:TriangleViewModel
    var scale:CGFloat
    
    //Viewにアニメーションをつけるプロパティ
    var offset: CGFloat{
        triangle.isOn ? 0.95 : 1.5
    }
    
    var opacity:Double{
        triangle.isOn ? 1 :0
    }
    
    var body:some View{
        DrawTriShape(in: triangle.vertexCoordinate, scale: scale, offset:offset)
            .stroke(Color.heavyRed, lineWidth: 2)
            .animation(.easeOut(duration: 0.5), value: offset)
            .opacity(opacity)
            .animation(.easeOut(duration: 0.5), value: opacity)
    }
    
}


