//
//  BaranceCircleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI
import Combine

struct BaranceCircleView: View {
    
    @EnvironmentObject private var stageModel: StageModel
    @StateObject private var circleViewModel = BaranceCircleViewModel()
    let circlePoint: CGPoint
    
    var body: some View {
        GeometryReader { geometry in
            let axisX = geometry.size.width / 20
            let axisY = geometry.size.width / 40
            let scaleX = geometry.size.width / axisX
            let scaleY = geometry.size.height / axisY
            let scale = sqrt(pow(scaleX, 2) + pow(scaleY, 2))
            ZStack {
                Section {
                    Ellipse()
                        .fill(stageModel.currentColor.light)
                        .scaleEffect(circleViewModel.clearCircleIsOn ? scale : 1)
                    Ellipse()
                        .fill(stageModel.currentColor.heavy)
                        .scaleEffect(circleViewModel.clearCircleIsOn ? scale - 0.3 : 0.7)
                }
                .frame(width: axisX * 2, height: axisY * 2)
                .position(circlePoint)
            }
        }
        .onAppear {
            circleViewModel.setUp(stageModel: stageModel)
        }
    }
}

final class BaranceCircleViewModel: ObservableObject {

    private var subscriber: AnyCancellable?
    private let clearSound: EffectSoundPlayer?
    
    init() {
        clearSound = EffectSoundPlayer(name: "clearSound")
    }
    
    func setUp(stageModel: StageModel) {
        subscriber = stageModel.gameEventPublisher.sink { [ weak self ] event in
            switch event.event {
            case .clearAnimation:
                self?.clearAnimation()
            case.gameClear:
                self?.gameClearAnimation()
                return
            default:
                return
            }
        }
    }
    //クリア時のアニメーション
    @Published private (set) var clearCircleIsOn = false
    private func clearAnimation() {
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            clearSound?.play()
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    clearCircleIsOn = true
                }
            }
            try await Task.sleep(nanoseconds: 550_000_000)
            await MainActor.run {
                self.clearCircleIsOn = false
            }
        }
    }
    private func gameClearAnimation() {
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            clearSound?.play()
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    clearCircleIsOn = true
                }
            }
            
            try await Task.sleep(nanoseconds: 3000_000_000)
            await MainActor.run {
                self.clearCircleIsOn = false
            }
        }
    }
}
