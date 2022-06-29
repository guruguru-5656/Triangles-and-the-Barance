//
//  ActionProgressView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/19.
//

import SwiftUI

struct ActionEffectView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @State var size: CGFloat
    @ObservedObject var itemContloller = GameModel.shared.itemController
    var body: some View {
        ForEach (itemContloller.actionEffectViewModel, id: \.id) { model in
            ActionEffectViewNormal(model: model, width: size)
        }
    }
}

struct ActionEffectViewNormal: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @State var model: ActionEffectViewModel
    @State var scale: CGFloat = 0.7
    @State var exrotation = Angle(degrees: -90)

    //stageTriangleのビューからサイズを指定する
    var width: CGFloat
    ///rotationEffectをかける際に位置ずれを防ぐため、frameをこの比率で設定
    var height:CGFloat {
        width / sqrt(3)
    }
    ///三角形の中心から描画する場合は回転エフェクトをかける
    private var rotation:Angle{
        if model.coordinate is TriangleCenterCoordinate {
            let remainder = model.coordinate.x % 2
            if remainder == 0{
                return Angle(degrees: 0)
            }else{
                return Angle(degrees: 180)
            }
        } else {
            return Angle(degrees: 0)
        }
    }
    var body: some View {
        DrawTriangleFromCenter()
            .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
            .frame(width: width, height: height)
            .rotationEffect(rotation)      
            .position(model.coordinate.drawPoint.scale(width))
            .transition(.asymmetric(insertion: .opacity.combined(with: .scale(scale: 1.5)),
                                    removal: .opacity))
    }
}
