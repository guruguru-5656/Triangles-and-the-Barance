//
//  ActionProgressView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/19.
//

import SwiftUI

struct ActionProgressView: View {
    @EnvironmentObject var gameModel: GameModel
    @State var size: CGFloat
    @ObservedObject var itemContloller = GameModel.shared.itemController
    var body: some View {
        if let item = itemContloller.progressingTapActionItem {
            switch item.action {
            case .normal:
                ActionProgressViewNormal(size: size, coordinate: item.coordinate)
            case .pyramid:
                ActionProgressViewNormal(size: size, coordinate: item.coordinate)
            }
        }
    }
}

struct ActionProgressViewNormal: View {
    @EnvironmentObject var gameModel: GameModel
    let coordinate: ModelCoordinate
    init(size: CGFloat, coordinate: ModelCoordinate) {
        self.width = size
        self.coordinate = coordinate
    }
    //stageTriangleのビューからサイズを指定する
    var width: CGFloat
    ///rotationEffectをかける際に位置ずれを防ぐため、frameをこの比率で設定
    var height:CGFloat{
        width / sqrt(3)
    }
    ///ModelCoordinateの座標系から実際に描画する際の中心ポイントを返す
    private var drawPoint:CGPoint{
        let X = CGFloat(coordinate.x)
        let Y = CGFloat(coordinate.y)
        
        let remainder = coordinate.x % 2
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
        let remainder = coordinate.x % 2
        if remainder == 0{
            return Angle(degrees: 0)
        }else{
            return Angle(degrees: 180)
        }
    }
    var body: some View {
        DrawTriangleFromCenter()
            .stroke(gameModel.currentColor.heavy, lineWidth: 2)
            .frame(width: width, height: height)
            .rotationEffect(rotation)
            .position(drawPoint)
    }
}
