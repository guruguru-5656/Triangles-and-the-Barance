//
//  BaranceViewModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import SwiftUI
import Combine
import AudioToolbox

class BaranceViewModel: ObservableObject {
    
    let stageModel: StageModel
    private var subscriber: AnyCancellable?
    private let clearSound: EffectSoundPlayer?
    
    init(stageModel: StageModel) {
        self.stageModel = stageModel
        clearSound = EffectSoundPlayer(name: "clearSound")
    }
    
    func subscribe() {
        subscriber = stageModel.gameEventPublisher
            .sink { event in
                switch event {
                case .triangleDeleted:
                    self.baranceAnimation()
                    self.hiLightAnimation()
                case .clearAnimation:
                    self.clearAnimation()
                case .resetGame:
                    self.baranceAnimation()
                default:
                    break
                }
            }
    }
    
    //天秤の角度のアニメーション
    private let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.5)
    @Published var angle: Double = Double.pi/16
    func baranceAnimation() {
        let clearPersent = Double(stageModel.deleteCount) / Double(stageModel.targetDeleteCount) > 1 ? 1 : Double(stageModel.deleteCount) / Double(stageModel.targetDeleteCount)
        withAnimation(angleAnimation) {
            angle = (1 - clearPersent) * Double.pi/16
        }
    }
    
    //一時的に白く光らせるアニメーション
    @Published var isTriangleHiLighted = false
    func hiLightAnimation() {
        withAnimation {
            isTriangleHiLighted = true
        }
        Task {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                withAnimation {
                    isTriangleHiLighted = false
                }
            }
        }
    }
    
    //テキストを一時的に表示するアニメーション
    @Published var deleteCountNow = 0
    @Published var showDeleteCountText = false
    func showTextAnimation(count: Int) {
        deleteCountNow = count
        withAnimation {
            showDeleteCountText = true
        }
        Task {
            try await Task.sleep(nanoseconds: 800_000_000)
            await MainActor.run {
                withAnimation {
                    showDeleteCountText = false
                }
            }
        }
    }
    
    //クリア時のアニメーション
    @Published var clearCircleIsOn = false
    func clearAnimation() {
        Task {
            await MainActor.run {
                withAnimation(.timingCurve(0.3, 0.2, 0.7, 0.4, duration: 0.5)) {
                    angle = -0.5 * Double.pi/16
                }
            }
            try await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    clearCircleIsOn = true
                }
            }
            clearSound?.play()
            try await Task.sleep(nanoseconds: 550_000_000)
            await MainActor.run {
                withAnimation(.linear(duration: 0.2)) {
                    angle = Double.pi/16
                }
            }
            try await Task.sleep(nanoseconds: 100_000_000)
            await MainActor.run {
                self.clearCircleIsOn = false
            }
        }
    }
}
