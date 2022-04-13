//
//  BaranceView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import SwiftUI

struct BaranceView: View {
    var baseScale: CGFloat {
        GameModel.shared.screenBounds.width/12
    }
    @EnvironmentObject var gameModel:GameModel
    @ObservedObject var baranceViewContloller = GameModel.shared.baranceViewContloller

    var opacity:Double{
        gameModel.parameter.clearPersent
    }
  
    var distance:Double{
        baseScale * 4 * sin(baranceViewContloller.angle)
    }
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                //垂れ下がっている部分
                Group{
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: baseScale/8, height: baseScale * 1.9)
                        .position(x: baseScale * 0.25, y: baseScale * 1 - distance)
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: baseScale/8, height: baseScale * 1.9)
                        .position(x: baseScale*7.75, y: baseScale * 1 + distance)
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale * 8, height: baseScale/4)
                        .rotationEffect(Angle(radians: baranceViewContloller.angle))
                        .position(x: baseScale * 4, y: baseScale/8)
                    Rectangle()
                        .foregroundColor(.lightGray)
                        .frame(width: baseScale/4, height: baseScale * 3)
                        .position(x: baseScale*4, y: baseScale * 1.5)
                }
                //中央の三角形
                Group{
                    TriangleNormalShape()
                        .frame(width: baseScale * 2, height: baseScale * sqrt(3))
                        .foregroundColor(gameModel.currentColor.light)
                        .position(x:baseScale * 4, y: baseScale * 2.8)
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width:baseScale/1.5, height:baseScale/1.5)
                        .position(x: baseScale * 4, y: baseScale / 6)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width:baseScale/3, height:baseScale/3)
                        .position(x: baseScale * 4, y: baseScale / 6)
                }
                //右側の円
                Group {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width:baseScale * 1.4, height:baseScale * 1.4 )
                        .position(x: baseScale * 7.75, y: baseScale * 1.8 + distance)
                    
                    Text(String(gameModel.parameter.targetDeleteCount))
                        .font(.title2)
                        .foregroundColor(Color(white: 0.1))
                        .position(x: baseScale * 7.75, y: baseScale * 1.8 + distance)
                }
                //左側の三角形の本体
                TriangleNormalShape()
                    .foregroundColor(.backgroundLightGray)
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                    .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                    
                Group {
                    TriangleNormalShape()
                        .foregroundColor(gameModel.currentColor.heavy)
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                    
                    Text(String(gameModel.parameter.deleteCount))
                        .font(.title2)
                        .foregroundColor(Color(white: 0.1))
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                }
                .opacity(opacity)
                if baranceViewContloller.isTriangleHiLighted {
                    TriangleNormalShape()
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 180))
                        .scaleEffect(1.1)
                        .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                        .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                        .blur(radius: 5)
                        .opacity(0.5)
                }
                if baranceViewContloller.showDeleteCountText {
                    Text("+\(gameModel.parameter.deleteCountNow)")
                        .font(.title2)
                        .foregroundColor(Color.backgroundLightGray)
                        .position(x: baseScale * 1.5, y: baseScale * 2 - distance)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(x: 0, y: -baseScale * 0.5)),
                            removal: .opacity))
                }
                
                //三角形のフレーム部分
                TriangleNormalShape()
                    .stroke(gameModel.currentColor.heavy)
                    .rotationEffect(Angle(degrees: 180))
                    .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                    .position(x: baseScale * 0.25, y: baseScale * 1.8 - distance)
                
                //クリア演出用の円
                if baranceViewContloller.clearCircleIsOn == false {
                    Ellipse()
                        .fill(gameModel.currentColor.light)
                        .frame(width: 30, height: 15)
                        .position(x: baseScale * 0.25, y: baseScale * 3.1)
                    
                    Ellipse()
                        .fill(gameModel.currentColor.heavy)
                        .frame(width: 20, height: 10)
                        .position(x: baseScale * 0.25, y: baseScale * 3.1)
                        .preference(key: ClearCirclePoint.self,
                                    value: CGPoint(
                                        x: geometry.frame(in: .global).origin.x + baseScale * 0.25 + 10,
                                        y: geometry.frame(in: .global).origin.y + baseScale * 3.1))
                    
                }   
            }.frame(width: baseScale * 8, height: baseScale * 4)
                .position(x: baseScale * 6, y: baseScale * 3 )
                
        }
    }
}

struct BaranceView_Previews: PreviewProvider {
    static var previews: some View {
        BaranceView()
            .environmentObject(GameModel.shared)
    }
}

class BaranceViewContloler: ObservableObject {
    let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.4)
    @Published var clearCircleSize: CGFloat = 1
    @Published var clearCircleIsOn = false
    @Published var angle: Double = Double.pi/16
    @Published var showDeleteCountText = false
    @Published var deleteCount = 0
    @Published var isTriangleHiLighted = false
    
    func baranceAnimation() {
        withAnimation(angleAnimation) {
            angle = (1 - GameModel.shared.parameter.clearPersent) * Double.pi/16
        }
        //消した数のテキストを一時的に表示
        withAnimation {
            showDeleteCountText = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                self.showDeleteCountText = false
            }
        }
        //ハイライトを表示
        withAnimation (.linear){
        isTriangleHiLighted = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation (.linear){
            self.isTriangleHiLighted = false
            }
        }
    }
    
    func clearAnimation(complesion: @escaping () -> Void) {
        withAnimation(.timingCurve(0.3, 0.2, 0.7, 0.4, duration: 0.3)) {
            angle = -0.7 * Double.pi/16
        }
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            self.clearCircleIsOn = true
            withAnimation(.easeOut(duration: 0.6)) {
                self.clearCircleSize = GameModel.shared.screenBounds.height * 2
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                self.clearCircleIsOn = false
                self.clearCircleSize = 1
                withAnimation(angleAnimation) {
                    self.angle = Double.pi/16
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                complesion()
            }
        }
    }
    
    func reset() {
        clearCircleSize = 1
        clearCircleIsOn = false
        angle = Double.pi/16
        deleteCount = 0
    }
}

struct ClearCirclePoint: PreferenceKey {
    typealias Value = CGPoint
    static var defaultValue = CGPoint(x: 0, y: 0)
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
