//
//  ScoreDifferenceTextView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/06.
//

import SwiftUI
import Combine

struct ScoreDifferenceTextView: View {
    @EnvironmentObject private var gameModel: GameModel
    @StateObject private var model = ScoreDifferenceTextViewModel()
    
    var body: some View {
        ZStack {
            if let text = model.text {
                Text("+" + text)
                    .foregroundColor(Color(white: 0.5 + Double(text.count) * 0.1))
            }
        }
        .onAppear {
            model.setUp(gameModel: gameModel)
        }
    }
}

class ScoreDifferenceTextViewModel: ObservableObject {
    @Published private (set) var text: String?
    private var subscriber: AnyCancellable?
    private var previousScore: Int = 0
    
    func setUp(gameModel: GameModel) {
        subscriber = gameModel.gameEventPublisher
            .sink { [weak self]
                event in
                switch event {
                case .triangleDeleted:
                    self?.showScoreDifference(gameModel.stageScore.scoreDifference)
                default:
                    break
                }
            }
    }
   
    private func showScoreDifference(_ difference: Int) {
        withAnimation {
            text = String(difference)
        }
        Task {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                withAnimation {
                    text = nil
                }
            }
        }
    }
}

struct ScoreDifferenceTextView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreDifferenceTextView()
    }
}
