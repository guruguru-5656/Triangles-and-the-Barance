

import Foundation
import SwiftUI

///メイン画面の三角形の描画
///位置をdrowpoint、向きrotationで指定する、それぞれtriangleModelのプロパティから計算してセット
struct TriangleFromCenterView: View, DrawTriangle {
    init(id:UUID,size:CGFloat){
        self.id = id
        self.width = size
    }
    @EnvironmentObject var stage:StageModel
    
    //親ビューからIDを割り当て、それをステージのモデルから検索することによってインデックス番号を取得する
    var id:UUID
    var index:Int{
        stage.triangles.firstIndex{ $0.id == self.id }!
    }
   
    //stageTriangleのビューからサイズを指定する
    var width: CGFloat
    
    ///三角形を描画する際にフレームの設定を.frame(width: scale ,height: height)の形で書くと回転したときに位置ずれしない
    var height:CGFloat{
        width / sqrt(3)
    }
    ///ModelCoordinateの座標系から実際に描画する際の中心ポイントを返す
    private var drawPoint:CGPoint{
        let X = CGFloat(stage.triangles[index].coordinate.x)
        let Y = CGFloat(stage.triangles[index].coordinate.y)
        
        let remainder = stage.triangles[index].coordinate.x % 2
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
        let remainder = stage.triangles[index].coordinate.x % 2
        if remainder == 0{
            return Angle(degrees: 0)
        }else{
            return Angle(degrees: 180)
        }
    }

    //Viewにアニメーションをつけるプロパティ
    //拡大率
    private var scale: CGFloat{
        switch stage.triangles[index].status{
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
        switch stage.triangles[index].status{
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
        switch stage.triangles[index].status{
        case .isOn:
            return 0.2
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
        switch stage.triangles[index].status{
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
            .stroke(Color.heavyRed, lineWidth: 2)
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
                .foregroundColor(.lightRed)
                .frame(width: width, height: height , alignment: .top)
                .rotationEffect(rotation)
                .scaleEffect(scale)
                .animation(.easeOut(duration: duration), value: scale)
                .position(drawPoint)
                .overlay(frameOfTriangle)
                .opacity(opacity)
                .animation(.easeIn(duration: duration), value: opacity)
                .onTapGesture {
                    withAnimation{
                        if stage.triangles[index].status == .isOn{
                            let action = TriangleTapAction(stage: stage, index: index)
                            stage.updateTrianglesStatusAndItem(action:action)
                            
                        }else{
                            //アイテムが入っていた場合はtrianglesにセット
                            if let selectedItemUnwraped = stage.selectedActionItem{
                                stage.triangles[index].action = selectedItemUnwraped.action
                                
                                stage.actionItems.removeFirst()
                                stage.selectedActionItem = nil
                            }
                            
                            stage.triangles[index].status = .isOn
                        }
                    }
                }
            //actionItemの描画
            if let actionItem = stage.triangles[index].action{
                switch actionItem{
                case .triforce:
                    ActionItem_TriforceView(width: width, height: height, rotation: rotation + Angle(degrees: 180), drawPoint: drawPoint)
                }
            }
        }
    }
}


