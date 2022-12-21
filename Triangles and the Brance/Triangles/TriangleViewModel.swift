//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Combine
import SwiftUI

final class TriangleViewModel: ObservableObject {
 
    @Published var triangles: [TriangleModel] = []
    @Published private(set) var fieldOutLine: [TriLine] = []
    @Published private(set) var triangleVertexs: [TriangleVertexCoordinate] = []
    @Published private(set) var fieldLine: [TriLine] = []
    @Published private(set) var numberOfCell: Int = 6
    @Published private (set) var field: TriangleField = TriangleField.loadField(1)
    private let soundPlayer = SEPlayer.shared
    private var subscribers: Set<AnyCancellable> = []
    
    func setUp(gameModel: GameModel) {
        gameModel.triangleManager.publisher
            .receive(on: DispatchQueue.main)
            .sink { [ weak self ] action in
            guard let self = self else { return }
                switch action {
                case .triangleStatusChange(let models):
                    models.forEach { self.updateStatus(model: $0) }
                case .playSound(let count):
                    self.playChainActionSound(index: count)
                case .setTriangleField(let field):
                    self.setField(field: field)
                }
        }
        .store(in: &subscribers)
        gameModel.triangleManager.initializeTriangleViewModel()
    }
    
    func setField(field: TriangleField) {
        triangles = field.triangles
        numberOfCell = field.numberOfCell
        fieldLine = field.fieldLines
        fieldOutLine = field.fieldOutLines
        triangleVertexs = field.vertex
    }
  
    private func updateStatus(model: TriangleModel) {
        guard let index = triangles.firstIndex(where: { $0.coordinate == model.coordinate }) else { return }
        triangles[index].status = model.status
    }

    ///indexで指定して音声を再生する
    ///用意している音声より後のindexを渡した場合は最後の部分を再生する
    private func playChainActionSound(index: Int) {
        let limitedIndex = index < 8 ? index + 1 : 8
        let sound = SEPlayer.Sound(rawValue: "marimba_" + String(limitedIndex))!
        soundPlayer.play(sound: sound)
    }
}
