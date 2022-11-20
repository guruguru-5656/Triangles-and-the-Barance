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
    @Published private(set) var descriptionItem: ActionType?
    @Published private(set) var energyDifference: Int?
   
    private let soundPlayer = SoundPlayer.instance
    
    init() {
        
    }
    //イベントの受信設定
    private var stageModel: StageModel!
    private var subscriber: AnyCancellable?
    func subscribe(stageModel: StageModel) {
        self.stageModel = stageModel
        loadItemTable()
        subscriber = self.stageModel.gameEventPublisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .itemUsed(let value):
                    self.soundPlayer.play(sound: .itemUsed)
                    self.showEnergyDifference(value * -1)
                case .triangleDeleted(let value):
                    self.showEnergyDifference(value)
                case .stageClear:
                    self.closeDescriptionView()
                    self.resetParameters()
                case .resetGame:
                    self.closeDescriptionView()
                    self.resetParameters()
                default:
                    return
                }
            }
    }
    
    func itemSelect(model: ActionItemModel) {
        closeDescriptionView()
        stageModel.itemSelect(model: model)
    }
    
    //説明Viewを表示し、一定時間後に閉じる
    private var task: Task<(), Error>?
    func showDescriptionView(item: ActionItemModel) {
        withAnimation {
            descriptionItem = item.type
        }
        task?.cancel()
        task = Task {
            do {
                try await Task.sleep(nanoseconds: 5000_000_000)
                await MainActor.run {
                    withAnimation {
                        descriptionItem = nil
                    }
                }
            } catch {
                return
            }
        }
    }
    
    func closeDescriptionView() {
        withAnimation {
            descriptionItem = nil
        }
        task?.cancel()
    }
    
    //テキストを一定時間表示
    private func showEnergyDifference(_ difference: Int) {
        withAnimation {
            energyDifference = difference
        }
        Task {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                withAnimation {
                    energyDifference = nil
                }
            }
        }
    }
    
    ///パラメーターを初期値に戻す
    private func resetParameters() {
        loadItemTable()
    }
    
    private func loadItemTable() {
        actionItems = ActionType.allCases.map { actionType -> ActionItemModel in
            if let upgradeType = UpgradeType(actionType: actionType){
                let saveData = stageModel.dataStore.loadData(name: upgradeType)
                return ActionItemModel(type: actionType, level: saveData)
            }
            return ActionItemModel(type: actionType, level: 1)
        }
    }
}
