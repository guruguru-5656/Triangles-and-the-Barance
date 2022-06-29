//
//  ItemController.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/26.
//

import SwiftUI

class ItemController: ObservableObject {
    
    @Published var actionItems: [ActionItemModel] = []
    @Published var selectedItem: ActionItemModel? 
    @Published var actionEffectViewModel: [ActionEffectViewModel] = []
    @Published var normalActionItem = ActionItemModel(action: .normal)
    @Published var normalActionCount: Int = 3
    @Published var inventory: Int = 1
    
    private var itemTable: [ItemForTable] = []
    private var defaultNormalActionCount:Int = 3
    
    func itemAction(coordinate: StageCoordinate) -> [[(Int, Int)]]{
        guard let item = selectedItem else {
            return []
        }
        switch item.action {
            //normalのアクションはその他のアイテムとは別の管理になっている
        case .normal:
            guard normalActionCount != 0 else{
                print("カウントゼロの状態で選択されている")
                return []
            }
            normalActionCount -= 1
        default:
            let indexOfItem = actionItems.firstIndex {
                $0.id == item.id
            }
            guard let indexOfItem = indexOfItem else {
                print("アイテムのインデックス取得エラー")
                return []
            }
            _ = withAnimation {
                actionItems.remove(at: indexOfItem)
            }
        }
        actionAnimation(coordinate: coordinate)
        selectedItem = nil
        return item.action.actionCoordinate
    }
    
    func itemSelectAction(model: ActionItemModel) {
        if selectedItem == nil {
            if model.action == .normal && normalActionCount == 0 {
                return
            }
            selectedItem = model
            
        } else {
            selectedItem = nil
        }
    }
    
    func actionAnimation(coordinate: StageCoordinate) {
        let model = ActionEffectViewModel(action: selectedItem!.action, coordinate: coordinate)
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
    ///triangleを消した数を受けて最大コストのactionItemを追加
    func appendStageItems(count: Int) {
        let table = itemTable.filter {
            $0.cost != nil
        }.sorted {
            $0.cost! > $1.cost!
        }
        for table in table{
            if count >= table.cost!{
                if actionItems.count == inventory {
                    _ = withAnimation {
                        actionItems.removeFirst()
                    }
                }
                withAnimation{
                    actionItems.append(ActionItemModel(action: table.type))
                }
                break
            }
        }
    }
    ///ゲームリセット時の挙動
    func resetGame() {
        actionItems = []
        selectedItem = nil
        actionEffectViewModel = []
        loadNormalActionCount()
        loadInventoryData()
        setItemTable()
        setParameters()
    }
    ///ステージクリア時の挙動
    func setParameters() {
        normalActionCount = defaultNormalActionCount
    }
    
    private func loadNormalActionCount() {
        let normalActionData = SaveData.shareData.shareUpgradeData(type: .normalActionCount)
        defaultNormalActionCount = normalActionData.level + 2
    }
    
    private func loadInventoryData() {
        let inventoryData = SaveData.shareData.shareUpgradeData(type: .inventory)
        inventory = inventoryData.level
    }
    
    private func setItemTable() {
        let upgradeData = SaveData.shareData.upgradeItems
        let table = ActionType.allCases.map { actionType -> ItemForTable in
            if let data = upgradeData.first (where: {
                $0.type == actionType.upgradeItem
            }) {
                return ItemForTable(type: actionType, level: data.level)
            } else {
                return ItemForTable(type: actionType, level: 0)
            }
        }
        self.itemTable = table
    }
    
    private struct ItemForTable {
        let type: ActionType
        let level: Int
        var cost: Int? {
            switch self.type {
                
            case .normal:
                return nil
            case .pyramid:
                switch level {
                case 1...2:
                    return 8
                case 3...5:
                    return 7
                case 6...9:
                    return 6
                case 10:
                    return 5
                default:
                    fatalError("想定外のレベル")
                }
            case .hexagon:
                return 12
            }
        }
    }
}
