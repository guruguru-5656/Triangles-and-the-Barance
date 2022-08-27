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
    @Published var selectedItem: ActionItemModel?
    @Published var actionEffectViewModel: [ActionEffectViewModel] = []
    @Published var energy: Int
    @Published var actionCount: Int
 
    init(stageModel: StageModel) {
        self.stageModel = stageModel
        //データの読み込み
        energy = 0
        actionCount = SaveData.shared.loadData(name: UpgradeType.actionCount) + 2
        loadItemTable()
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
                    self.resetParameters()
                case .resetGame:
                    self.resetParameters()
                case .initialize:
                    return
                case .triangleDeleted:
                    return
                case .clearAnimation:
                    return
                case .gameOver:
                    return
                }
            }
    }
    
    func itemAction<T: StageCoordinate>(coordinate: T) -> [[(Int, Int)]]{
        //アイテムが選択されていなければ何もしない
        guard let item = selectedItem else {
            return []
        }
        //入力された座標がitemのpositionと一致しない場合選択解除を行う
        guard coordinate.position == item.type.position else{
            selectedItem = nil
            return []
        }

        selectedItem = nil
        actionCount -= 1
        return item.type.actionCoordinate
    }    
   
    func itemSelect(model: ActionItemModel) {
        guard actionCount > 0 else {
            return
        }
        //現在選択しているItemと同じものを選択した場合、選択を解除する
        if model.id == selectedItem?.id {
            selectedItem = nil
            return
        }
        //コストが現在のエネルギーより小さい場合は選択する
        if model.cost ?? .max <= energy {
            selectedItem = model
            
        }
        return
    }
    
    func actionAnimation(coordinate: StageCoordinate) {
        let model = ActionEffectViewModel(action: selectedItem!.type, coordinate: coordinate)
        withAnimation {
            actionEffectViewModel.append(model)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let index = self.actionEffectViewModel.firstIndex {
                $0.id == model.id
            }
            if let index = index {
                _ = withAnimation {
                    self.actionEffectViewModel.remove(at: index)
                }
            }
        }
    }

    ///パラメーターを初期値に戻す
    func resetParameters() {
        loadItemTable()
        actionCount = SaveData.shared.loadData(name: UpgradeType.actionCount) + 2
        energy = 0
        selectedItem = nil
    }
 
    private func loadItemTable() {
        actionItems = ActionType.allCases.map { actionType -> ActionItemModel in
            if let upgradeType = UpgradeType(actionType: actionType){
                let saveData = SaveData.shared.loadData(name: upgradeType)
                return ActionItemModel(type: actionType, level: saveData)
            }
            return ActionItemModel(type: actionType, level: 1)
        }
    }
}
