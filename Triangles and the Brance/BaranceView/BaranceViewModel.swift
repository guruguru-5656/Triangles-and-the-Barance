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
    
    private var stageModel: StageModel?
    private var subscriber: AnyCancellable?
    
    func setUp(stageModel: StageModel) {
        self.stageModel = stageModel
        subscriber = stageModel.gameEventPublisher
            .sink { completion in
                switch completion.event {
                case .triangleDeleted:
                    self.baranceAnimation()
                    self.hiLightAnimation()
                case .clearAnimation:
                    self.stageClearAnimation()
                case .resetGame:
                    self.baranceAnimation()
                case .gameClear:
                    self.gameClearAnimation()
                default:
                    break
                }
            }
    }

    //天秤の角度のアニメーション
    private let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.5)
    @Published private (set) var angle: Double = Double.pi/16
    private func baranceAnimation() {
         guard let stageModel = stageModel else {
             return
         }
         let clearPercent = Double(stageModel.deleteCount) / Double(stageModel.targetDeleteCount) > 1 ? 1 : Double(stageModel.deleteCount) / Double(stageModel.targetDeleteCount)
         withAnimation(angleAnimation) {
             angle = (1 - clearPercent) * Double.pi/16
         }
     }
    
    //一時的に白く光らせるアニメーション
    @Published private (set) var isTriangleHiLighted = false
    
    private func hiLightAnimation() {
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
    @Published private (set) var deleteCountNow = 0
    @Published private (set) var showDeleteCountText = false
    
    private func showTextAnimation(count: Int) {
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
    
   
    private func stageClearAnimation() {
        Task {
            await MainActor.run {
                withAnimation(.timingCurve(0.3, 0.2, 0.7, 0.4, duration: 0.5)) {
                    angle = -0.5 * Double.pi/16
                }
            }
            try await Task.sleep(nanoseconds: 1050_000_000)
            await MainActor.run {
                withAnimation(.linear(duration: 0.2)) {
                    angle = Double.pi/16
                }
            }
            
        }
    }
    
    private func gameClearAnimation() {
        Task {
            await MainActor.run {
                withAnimation(.timingCurve(0.3, 0.2, 0.7, 0.4, duration: 0.5)) {
                    angle = -0.5 * Double.pi/16
                }
            }
        }
    }
}
