

import Foundation
import SwiftUI

struct TriangleView: View {
    @EnvironmentObject var gameModel: GameModel
    @ObservedObject var contloller = GameModel.shared.triangleController
    @State var size: CGFloat
    @State var backGround = StaticStageObjects()
    
    var body: some View {
        ZStack{
        //背景
        DrawShapeFromVertexCoordinate(coordinates: backGround.hexagon, scale: size)
            .foregroundColor(.backgroundLightGray)
            .scaleEffect(1.05)
        //背景の線部分
        ForEach(backGround.stageLines){ line in
            DrawTriLine(line: line, scale: size)
                .stroke(gameModel.currentColor.heavy, lineWidth: 1)
        }
        
        //メインの三角形の表示
        ForEach($contloller.triangles){ $triangle in
            TriangleFromCenterView(model: $triangle, width: size)
                .onTapGesture {
                    contloller.triangleTapAction(coordinate: triangle.coordinate)
                }
        }
        }
    }
}
///メイン画面の三角形の描画
///位置をdrowpoint、向きrotationで指定する、それぞれtriangleModelのプロパティから計算してセット
struct TriangleFromCenterView: View, DrawTriangle {
    
    @EnvironmentObject var gameModel:GameModel
    @Binding var model: TriangleViewModel
    
    //stageTriangleのビューからサイズを指定する
    var width: CGFloat
    ///rotationEffectをかける際に位置ずれを防ぐため、frameをこの比率で設定
    internal var height:CGFloat{
        width / sqrt(3)
    }
    ///ModelCoordinateの座標系から実際に描画する際の中心ポイントを返す
    private var drawPoint:CGPoint{
        let X = CGFloat(model.coordinate.x)
        let Y = CGFloat(model.coordinate.y)

        let remainder = model.coordinate.x % 2
        if remainder == 0{
            return CGPoint(x: (X/2 + Y/2) * width, y: Y * sqrt(3)/2 * width)
        }else{
            //正三角形を180度回転したときに生じる中心地点のずれ
            let distance = sqrt(3)/2 - 1/sqrt(3)
            return CGPoint(x: (X/2 + Y/2) * width, y: (distance + sqrt(3)/2 * Y) * width)
        }
    }
    ///与えられた座標のX座標をもとに回転するかどうか判断する
    private var rotation:Angle{
        let remainder = model.coordinate.x % 2
        if remainder == 0{
            return Angle(degrees: 0)
        }else{
            return Angle(degrees: 180)
        }
    }
    //Viewにアニメーションをつけるプロパティ
    //拡大率
    private var scale: CGFloat{
        switch model.status{
        case .isOn:
           return 0.95
        case .isDisappearing:
           return 0.95
        case .isOff:
            return 1.1
        case .onAppear:
            return 1.1
        }
    }
    //透過度
    private var opacity:Double{
        switch model.status{
        case .isOn:
           return 1
        case .isDisappearing:
           return 1
        case .isOff:
            return 0.001
        case .onAppear:
            return 0.001
        }
    }
    //アニメーションの時間指定
    private var duration:Double{
        switch model.status{
        case .isOn:
            return 0.3
        case .isDisappearing:
            return 0.5
        case .isOff:
            return 0.5
        case .onAppear:
            return 0.5
        }
    }
    //フレームにアニメーションをつけるプロパティ
    private var frameScale: CGFloat{
        switch model.status{
        case .isOn:
            return 0.95
        case .isDisappearing:
            return 0.95
        case .isOff:
            return 1.6
        case .onAppear:
            return 1.6
        }
    }
    //フレーム部分の描画
    private var frameOfTriangle:some View{
        DrawTriangleFromCenter()
            .stroke(gameModel.currentColor.heavy, lineWidth: 2)
            .frame(width: width, height: height , alignment: .center)
            .rotationEffect(rotation)
            .scaleEffect(frameScale)
            .animation(.easeOut(duration: duration), value: frameScale)
            .position(drawPoint)
            .opacity(opacity)
            .animation(.easeOut(duration: duration), value: opacity)
    }

    //本体の描画
    var body: some View {
        ZStack{
        DrawTriangleFromCenter()
                .foregroundColor(gameModel.currentColor.light)
                .frame(width: width, height: height , alignment: .top)
                .rotationEffect(rotation)
                .scaleEffect(scale)
                .animation(.easeOut(duration: duration), value: scale)
                .position(drawPoint)
                .overlay(frameOfTriangle)
                .opacity(opacity)
                .animation(.easeIn(duration: duration), value: opacity)
        }
    }
}


