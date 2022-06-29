

import Foundation
import SwiftUI

struct TriangleView: View {
    @EnvironmentObject private var viewEnvironment: ViewEnvironment
    @ObservedObject private var controller = GameModel.shared.triangleController
    @ObservedObject private var itemController = GameModel.shared.itemController
    @State var size: CGFloat
    @State var backGround = StaticStageObjects()
    var isVertexHilighted: Bool {
            itemController.selectedItem?.action.position == .vertex ? true : false
    }
    
    var body: some View {
        ZStack{
            //背景
            DrawShapeFromVertexCoordinate(coordinates: backGround.hexagon, scale: size)
                .foregroundColor(.backgroundLightGray)
                .scaleEffect(1.08)
            //背景の線部分
            ForEach(backGround.stageLines){ line in
                DrawTriLine(line: line, scale: size)
                    .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
            }
            //メインの三角形の表示
            ForEach($controller.triangles){ $triangle in
                StageTriangleView(model: $triangle, width: size)
                    .onTapGesture {
                        controller.triangleTapAction(coordinate: triangle.coordinate)
                    }
            }
            if isVertexHilighted {
                ForEach(controller.triangleVertexs, id: \.self) { coordinate in
                    Circle()
                        .frame(width: size * 0.7, height: size * 0.7)
                        .position(coordinate.drawPoint.scale(size))
                        .foregroundColor(Color(white: 0.9, opacity: 0.5))
                        .onTapGesture {
                            controller.triangleVertexTapAction(coordinate: coordinate)
                        }
                }
            }
        }
    }
}
///メイン画面の三角形の描画
///位置をdrowpoint、向きrotationで指定する、それぞれtriangleModelのプロパティから計算してセット
struct StageTriangleView: View, DrawTriangle {
    
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @Binding var model: TriangleViewModel
    
    //stageTriangleのビューからサイズを指定する
    var width: CGFloat
    ///rotationEffectをかける際に位置ずれを防ぐため、frameをこの比率で設定
    var height:CGFloat{
        width / sqrt(3)
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
            .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
            .frame(width: width, height: height , alignment: .center)
            .rotationEffect(rotation)
            .scaleEffect(frameScale)
            .animation(.easeOut(duration: duration), value: frameScale)
            .position(model.coordinate.drawPoint.scale(width))
            .opacity(opacity)
            .animation(.easeOut(duration: duration), value: opacity)
    }
    //本体の描画
    var body: some View {
        DrawTriangleFromCenter()
                .foregroundColor(viewEnvironment.currentColor.light)
                .frame(width: width, height: height , alignment: .top)
                .rotationEffect(rotation)
                .scaleEffect(scale)
                .animation(.easeOut(duration: duration), value: scale)
                .position(model.coordinate.drawPoint.scale(width))
                .overlay(frameOfTriangle)
                .opacity(opacity)
                .animation(.easeIn(duration: duration), value: opacity)
    }
}


extension CGPoint {
    func scale(_ scale: CGFloat) -> CGPoint {
        let X = self.x * scale
        let Y = self.y * scale
        return CGPoint(x: X, y: Y)
    }
}
