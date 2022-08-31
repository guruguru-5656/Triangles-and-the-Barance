//
//  BaranceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import SwiftUI
import Combine

struct BaranceView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @ObservedObject var model = GameModel.shared.baranceViewModel

    let size: CGFloat
    var baseScale: CGFloat {
        size / 8
    }
    var opacity:Double {
        Double(model.stageModel.deleteCount) / Double(model.stageModel.targetDeleteCount) > 1 ? 1 : Double(model.stageModel.deleteCount) / Double(model.stageModel.targetDeleteCount)
    }
    var distance:Double {
        return baseScale * 3.25 * sin(model.angle)
    }
    
    var body: some View {
            GeometryReader { geometry in
                //左右に伸びる棒
                Group {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: baseScale / 8, height: baseScale * 1.5)
                        .position(x: baseScale * 1, y: baseScale * 1.25 - distance)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: baseScale / 8, height: baseScale * 1.5)
                        .position(x: baseScale * 7, y: baseScale * 1.25 + distance)
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale * 6.5, height: baseScale / 4)
                        .rotationEffect(Angle(radians: model.angle))
                        .position(x: baseScale * 4, y: baseScale * 0.5)
                }
                //中央部分
                Group {
                    Rectangle()
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale / 4, height: baseScale * 2)
                        .position(x: baseScale * 4, y: baseScale * 1.5)
                    TriangleNormalShape()
                        .frame(width: baseScale * 2, height: baseScale * 2 * sqrt(3)/2)
                        .foregroundColor(viewEnvironment.currentColor.light)
                        .position(x:baseScale * 4, y: baseScale * 2.8)
                    RegularPolygon(vertexNumber: 6)
                        .foregroundColor(.gray)
                        .frame(width:baseScale * 0.8, height:baseScale * 0.8)
                        .position(x: baseScale * 4, y: baseScale * 0.5)
                }
                //右側
                TriangleNormalShape()
                    .foregroundColor(.gray)
                    .overlay {
                        Text(String(model.stageModel.targetDeleteCount))
                            .font(.title2)
                            .foregroundColor(Color(white: 0.1))
                    }
                    .frame(width: baseScale * sqrt(3), height: baseScale *
                           1.5 )
                    .position(x: baseScale * 7, y: baseScale * 2 + distance)
                
                //左側の三角形
                Group {
                    TriangleNormalShape()
                        .foregroundColor(.backgroundLightGray)
                        .rotationEffect(Angle(degrees: 180))
                    TriangleNormalShape()
                        .foregroundColor(viewEnvironment.currentColor.heavy)
                        .rotationEffect(Angle(degrees: 180))
                    
                        .opacity(opacity)
                    Text(String(model.stageModel.deleteCount))
                        .font(.title2)
                        .foregroundColor(Color(white: 0.1))
                        .opacity((1 + opacity) / 2)
                    if model.isTriangleHiLighted {
                        TriangleNormalShape()
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 180))
                            .scaleEffect(1.1)
                            .blur(radius: 5)
                            .opacity(0.5)
                    }
                }
                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                .position(x: baseScale * 1, y: baseScale * 1.8 - distance)
                if model.showDeleteCountText {
                    Text("+\(model.stageModel.deleteCount)")
                        .font(.title2)
                        .foregroundColor(Color.backgroundLightGray)
                        .position(x: baseScale * 2, y: baseScale * 2 - distance)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(x: 0, y: -baseScale * 0.5)),
                            removal: .opacity))
                }
            }
            .anchorPreference(key: ClearCirclePoint.self, value: Anchor.Source.bounds) { $0 }
    }
}

//viewの円の位置を伝えるための構造体
struct ClearCirclePoint: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
