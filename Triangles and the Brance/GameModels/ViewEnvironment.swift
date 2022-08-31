//
//  ViewEnvironment.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/24.
//

import Combine
import SwiftUI

class ViewEnvironment: ObservableObject{
    
    @Published var currentColor: StageColor
    init(stageModel: StageModel) {
        self.stageModel = stageModel
        currentColor = StageColor(stage: stageModel.stage)
    }
    //イベントの受信設定
    private let stageModel: StageModel
    private var subscriber: AnyCancellable?
    func subscribe() {
        subscriber = stageModel.gameEventPublisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .stageClear:
                    self.stageClear()
                case .resetGame:
                    self.resetGame()
                default:
                    break
                }
            }
    }
    
    func resetGame() {
        currentColor = StageColor(stage: 1)
    }
    
    func stageClear() {
        currentColor.nextColor()
    }
}
