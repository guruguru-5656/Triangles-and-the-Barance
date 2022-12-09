//
//  BaranceViewModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import SwiftUI
import Combine

class BaranceViewModel: ObservableObject {
    @Published private (set) var deleteCountNow = 0
    @Published private (set) var showDeleteCountText = false
    @Published private (set) var isTriangleHiLighted = false
    @Published private (set) var angle: Double = Double.pi/16
    private let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.5)
    private var subscriber: AnyCancellable?
    
    func setUp(eventSubject: PassthroughSubject<GameEvent, Never>) {
        subscriber = eventSubject
            .sink { [weak self] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .startStage:
                    self.baranceAnimation(clearPercent: 0)
                case .triangleDeleted(let count, let clearPercent):
                    self.baranceAnimation(clearPercent: clearPercent)
                    self.showTextAnimation(count: count)
                    self.hiLightAnimation()
                case .clearAnimation:
                    self.stageClearAnimation()
                case .gameClear:
                    self.gameClearAnimation()
                default:
                    break
                }
            }
    }
    
    private func baranceAnimation(clearPercent: Double) {
        withAnimation(angleAnimation) {
            angle = (1 - clearPercent) * Double.pi/16
        }
    }
    
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
