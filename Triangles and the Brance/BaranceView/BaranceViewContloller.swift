//
//  BaranceViewContloller.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

class BaranceViewContloler: ObservableObject {
    let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.5)
    @Published var clearCircleIsOn = false
    @Published var angle: Double = Double.pi/16
    @Published var showDeleteCountText = false
    @Published var deleteCount = 0
    @Published var isTriangleHiLighted = false
    @Published var deleteCountNow = 0
    @Published var clearPersent: Double = 0

    func baranceAnimation() {
        let deleteCount = Double(GameModel.shared.stageModel.deleteCount)
        let targetDeleteCount = Double(GameModel.shared.stageModel.targetDeleteCount)
        clearPersent = deleteCount / targetDeleteCount > 1 ? 1 : deleteCount / targetDeleteCount
        withAnimation(angleAnimation) {
            angle = (1 - clearPersent) * Double.pi/16
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
        
        withAnimation(.timingCurve(0.3, 0.2, 0.7, 0.4, duration: 0.5)) {
            angle = -0.5 * Double.pi/16
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            withAnimation(.easeOut(duration: 0.5)) {
                self.clearCircleIsOn = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.001) { [self] in
            self.clearCircleIsOn = false
            self.clearPersent = 0
            withAnimation {
                angle = Double.pi/16
            }
            complesion()
        }
    }
    
    func resetGame() {
        clearCircleIsOn = false
        clearPersent = 0
        angle = Double.pi/16
        deleteCount = 0
    }
}

struct ClearCirclePoint: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
