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
    @Published var energy: Int = 0
    @Published var numberOfItems = 3
    
    init(stageModel: StageModel) {
        self.stageModel = stageModel
    }
    //イベントの受信設定
    private let stageModel: StageModel
    private var subscriber: AnyCancellable?
    func subscribe() {
        subscriber = stageModel.publisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .stageClear:
                    self.setParameters()
                case .resetGame:
                    self.setParameters()
                default:
                    break
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
        numberOfItems -= 1
        return item.type.actionCoordinate
    }    
   
    func itemSelect(model: ActionItemModel) {
        guard numberOfItems > 0 else {
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
    func setParameters() {
        setItemTable()
        energy = 0
        //TODO: データロード
        numberOfItems = 3
        
        selectedItem = nil
    }
 
    private func loadNumberOfItems(_ upgradeData: [UpgradeItemViewModel]) {
        let data = upgradeData.first{
            $0.type == .actionCount
        }
        guard let data = data else {
            print("NumberObItemsの読み込みエラー")
            return
        }
        numberOfItems = data.level + 2
    }
    private func setItemTable() {
        let upgradeData = SaveData.shareData.loadUpgradeData()
        let items = ActionType.allCases.map { actionType -> ActionItemModel in
            if let data = upgradeData.first (where: { data in
                data.type.actionType == actionType
            }) {
                return ActionItemModel(type: actionType, level: data.level)
            } else {
                return ActionItemModel(type: actionType, level: 1)
            }
        }
        actionItems = items
        loadNumberOfItems(upgradeData)
    }
    
}
