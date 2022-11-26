

import Foundation
import SwiftUI

struct TriangleView: View {
    @EnvironmentObject private var gameModel: GameModel
    @StateObject private var controller = TriangleContloller()

    var isVertexHilighted: Bool {
        gameModel.selectedItem?.type.position == .vertex
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top){
            //背景
                DrawShapeFromTriLines(lines: controller.fieldOutLine, scale: geometry.size.width / CGFloat(controller.numberOfCell))
                .foregroundColor(.backgroundLightGray)
                .scaleEffect(1.1)
            //背景の線部分
            ForEach(controller.fieldLine){ line in
                DrawTriLine(line: line, scale: geometry.size.width / CGFloat(controller.numberOfCell))
                    .stroke(gameModel.currentColor.heavy, lineWidth: 1)
            }
            //メインの三角形の表示
            ForEach($controller.triangles){ $triangle in
                StageTriangleView(currentColor: gameModel.currentColor, model: $triangle, width: geometry.size.width / CGFloat(controller.numberOfCell))
                    .onTapGesture {
                        controller.triangleTapAction(coordinate: triangle.coordinate)
                    }
            }
            //頂点部分からアクションを起こすitemを選択している時に表示する
            if isVertexHilighted {
                ForEach(controller.triangleVertexs, id: \.self) { coordinate in
                    Circle()
                        .frame(width: geometry.size.width / CGFloat(controller.numberOfCell) * 0.7, height: geometry.size.width / CGFloat(controller.numberOfCell) * 0.7)
                        .position(coordinate.drawPoint.scale(geometry.size.width / CGFloat(controller.numberOfCell)))
                        .foregroundColor(Color(white: 0.9, opacity: 0.5))
                        .onTapGesture {
                            controller.itemAction(coordinate: coordinate)
                        }
                }
            }
        }
        }
        .onAppear {
            controller.setUp(gameModel: gameModel)
        }
    }
}

///メイン画面の三角形の描画
///位置をdrowpoint、向きrotationで指定する、それぞれtriangleModelのプロパティから計算してセット
struct StageTriangleView: View, DrawTriangle {
    
    let currentColor: StageColor
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
            .stroke(currentColor.heavy, lineWidth: 2)
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
                .foregroundColor(currentColor.light)
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
