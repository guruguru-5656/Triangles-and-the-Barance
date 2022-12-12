//
//  ItemController.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/26.
//

import SwiftUI
import Combine

class ItemController: ObservableObject {
    
    @Published var actionItems: [ActionItemModel] = []
    private let soundPlayer = SEPlayer.shared
    
    //イベントの受信設定
    private var gameModel: GameModel!
    private var subscriber: AnyCancellable?
    func subscribe(gameModel: GameModel) {
        self.gameModel = gameModel
        loadItemTable()
        subscriber = self.gameModel.gameEventPublisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .itemUsed:
                    self.soundPlayer.play(sound: .itemUsed)
                case .startStage:
                    self.resetParameters()
                default:
                    return
                }
            }
    }
    
    func itemSelect(model: ActionItemModel) {
        gameModel.itemSelect(model: model)
    }

    ///パラメーターを初期値に戻す
    private func resetParameters() {
        loadItemTable()
    }
    
    private func loadItemTable() {
        actionItems = ActionType.allCases.map { actionType -> ActionItemModel in
            if let upgradeType = UpgradeType(actionType: actionType){
                let saveData = gameModel.dataStore.loadData(name: upgradeType)
                return ActionItemModel(type: actionType, level: saveData)
            }
            return ActionItemModel(type: actionType, level: 1)
        }
    }
}
