//
//  DrawTriangleFromCenter.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/17.
//

import SwiftUI

///メイン画面の三角形の描画
///位置をdrowpoint、向きrotationで指定する、それぞれtriangleModelのプロパティから計算してセット
struct TriangleFromCenterView: View, DrawTriangle {
    init(model:TriangleViewModel,size:CGFloat){
        self.triangleModel = model
        self.size = size
    }
    
    @EnvironmentObject var stage:StageModel
    @ObservedObject var triangleModel:TriangleViewModel
    var coordinate:ModelCoordinate{
        triangleModel.modelCoordinate
    }
    var size: CGFloat
   
    ///三角形を描画する際にフレームの設定を.frame(width: scale ,height: height)の形で書くと回転したときに位置ずれしない
    var height:CGFloat{
        size / sqrt(3)
    }
    ///ModelCoordinateの座標系から実際に描画する際の中心ポイントを返す
    var drawPoint:CGPoint{
        let X = CGFloat(coordinate.x)
        let Y = CGFloat(coordinate.y)
        
        let remainder = coordinate.x % 2
        if remainder == 0{
            return CGPoint(x: (X/2 + Y/2) * size, y: Y * sqrt(3)/2 * size)
        }else{
            //正三角形を180度回転したときに生じる中心地点のずれ
            let distance = sqrt(3)/2 - 1/sqrt(3)
            return CGPoint(x: (X/2 + Y/2) * size, y: (distance + sqrt(3)/2 * Y) * size)
        }
    }
    ///与えられた座標のX座標をもとに回転するかどうか判断する
    var rotation:Angle{
        let remainder = coordinate.x % 2
        if remainder == 0{
            return Angle(degrees: 0)
        }else{
            return Angle(degrees: 180)
        }
    }
  
    //Viewにアニメーションをつけるプロパティ
    //拡大率
    var scale: CGFloat{
        switch triangleModel.status{
        case .isOn:
           return 0.95
        case .isDisappearing:
           return 0.95
        case .isOff:
            return 1.1
        }
    }
    //透過度
    var opacity:Double{
        switch triangleModel.status{
        case .isOn:
           return 1
        case .isDisappearing:
           return 1
        case .isOff:
            return 0
        }
    }
    //アニメーションの時間指定
    var duration:Double{
        switch triangleModel.status{
        case .isOn:
            return 0.2
        case .isDisappearing:
            return 0.5
        case .isOff:
            return 0.5
        }
    }
    
    //フレームにアニメーションをつけるプロパティ
    var frameScale: CGFloat{
        switch triangleModel.status{
        case .isOn:
            return 0.95
        case .isDisappearing:
            return 0.95
        case .isOff:
            return 1.6
        }
    }
    
    
    ///フレーム部分の描画
    var frameOfTriangle:some View{
        DrawTriangleFromCenter()
            .stroke(Color.heavyRed, lineWidth: 2)
            .frame(width: size, height: height , alignment: .center)
            .rotationEffect(rotation)
            .position(drawPoint)

            .scaleEffect(frameScale)
            .animation(.easeOut(duration: duration), value: frameScale)
            
            .animation(.easeOut(duration: duration), value: opacity)
    }
    
    var body: some View {
        ZStack{
        DrawTriangleFromCenter()
                .foregroundColor(.lightRed)
                .frame(width: size, height: height , alignment: .center)
                .rotationEffect(rotation)
                .position(drawPoint)
                .scaleEffect(scale)
                .overlay(frameOfTriangle)
                .opacity(opacity)
                .onTapGesture {
                    print("tap!")
                    //                if let selectedItem = stage.selectedItem{
                    //                    switch selectedItem.type{
                    //                    case .normal:
                    //                        fallthrough
                    //                    case .triforce:
                    //                        stage.stageTriangles[index].action = .triforce
                    //                    }
                    //                }else{
                    //                    stage.deleteTrianglesInput(index: index)
                    //                }
                }
//              DrawTriangleFromCenter()
//                .stroke(Color.heavyRed, lineWidth: 2)
//                .frame(width: size, height: height , alignment: .center)
//                .rotationEffect(rotation)
//                .position(drawPoint)
//                .scaleEffect(frameScale)
//                .animation(.easeOut(duration: duration), value: frameScale)
//                .opacity(opacity)
//                .animation(.easeOut(duration: duration), value: opacity)
        }
    }
}


///正三角形を描画するShape
///回転エフェクトを正常に機能させるために、呼出時はwidth:heightが1:1/sqrt(3)の比率になるように呼びだす
struct DrawTriangleFromCenter:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxX * sqrt(3)/2))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
    
}

///DrawTriangleFromCenterを呼び出すときに必要なパラメータを設定する
protocol DrawTriangle{
    var scale:CGFloat{ get }
    var height:CGFloat{ get }
//    func getDrawPoint(from coordinate:ModelCoordinate,scale:CGFloat) -> CGPoint
}

///デフォルト実装
extension DrawTriangle{
    
   
}
