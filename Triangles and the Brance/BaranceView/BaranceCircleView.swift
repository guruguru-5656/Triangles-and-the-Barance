//
//  BaranceCircleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI
import Combine

struct BaranceCircleView: View {
    
    @EnvironmentObject private var gameModel: GameModel
    @StateObject private var circleViewModel = BaranceCircleViewModel()
    let circlePoint: CGPoint
    
    var body: some View {
        GeometryReader { geometry in
            let axisX = geometry.size.width / 20
            let axisY = geometry.size.width / 40
            let scale = sqrt(pow(geometry.size.width, 2) + pow(geometry.size.height, 2)) / axisY
            ZStack {
                Section {
                    Ellipse()
                        .fill(gameModel.currentColor.light)
                        .scaleEffect(circleViewModel.clearCircleIsOn ? scale : 1)
                    Ellipse()
                        .fill(gameModel.currentColor.heavy)
                        .scaleEffect(circleViewModel.clearCircleIsOn ? scale - 0.3 : 0.7)
                }
                .frame(width: axisX * 2, height: axisY * 2)
                .position(circlePoint)
            }
        }
        .onAppear {
            circleViewModel.setUp(gameModel: gameModel)
        }
    }
}

final class BaranceCircleViewModel: ObservableObject {

    private var subscriber: Set<AnyCancellable> = []

    func setUp(gameModel: GameModel) {
        gameModel.clearAnimationPublisher.sink { [weak self] in
            self?.clearAnimation()
        }.store(in: &subscriber)
        gameModel.gameClearPublisher.sink { [weak self] in
            self?.gameClearAnimation()
        }.store(in: &subscriber)
        gameModel.startStagePublisher.sink { [weak self] stage in
            if stage == 1 {
                self?.clearCircleIsOn = false
            }
        }.store(in: &subscriber)
    }
    //クリア時のアニメーション
    @Published private (set) var clearCircleIsOn = false
    private func clearAnimation() {
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
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
            await MainActor.run {
                withAnimation(.easeOut(duration: 0.5)) {
                    clearCircleIsOn = true
                }
            }
        }
    }
}
