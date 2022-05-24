//
//  BaranceViewContloller.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

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
