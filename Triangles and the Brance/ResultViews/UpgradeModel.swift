//
//  UpGradeModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import SwiftUI

class UpgradeViewModel: ObservableObject {
    @Published var upgradeItems: [UpgradeItemViewModel]
    @Published var money: Int
    @Published var payingMoney = 0
    //キャンセル用の一時的なデータ
    private var previousItems: [UpgradeItemViewModel] = []

    init(){
        upgradeItems = SaveData.shareData.upgradeItems.enumerated().map{ item in
            UpgradeItemViewModel(id: item.offset, status: item.element)
        }
        money = SaveData.shareData.money
    }
    //itemsにこのクラスへの参照を配る
    func setItemsParent() {
        upgradeItems.indices.forEach{
            upgradeItems[$0].parentModel = self
        }
    }
   
    //キャンセルされたときのために用意
    func setPreviousStatus() {
        previousItems = upgradeItems
        money = SaveData.shareData.money
        payingMoney = 0
    }
    func cancel() {
        upgradeItems = previousItems
        money = SaveData.shareData.money
        payingMoney = 0
        withAnimation {
        GameModel.shared.score.showUpgrade = false
        }
    }
    func permitPaying() {
        SaveData.shareData.upgradeItems = upgradeItems.map{
            $0.upgradeStatus
        }
        SaveData.shareData.money = money
        withAnimation {
        GameModel.shared.score.showUpgrade = false
        }
    }
}

//UpgradeSubViewのモデル
struct UpgradeItemViewModel: Identifiable {
    //id、生成時にインデックス番号を割り当てる
    let id:Int
    var upgradeStatus: UpgradeItemModel
    //親クラスの参照
    fileprivate weak var parentModel: UpgradeViewModel?
    fileprivate init(id:Int, status: UpgradeItemModel) {
        self.id = id
        upgradeStatus = status
    }
    

    mutating func upgrade(){
        guard let parentModel = parentModel else {
            return
        }
        parentModel.money -= cost
        parentModel.payingMoney += cost
        upgradeStatus.level += 1
    }
    ///10のレベル乗をinitialCostにかける
    var cost: Int {
        upgradeStatus.initialCost * Int(pow(Double(10), Double(upgradeStatus.level + 1)))
    }
    //アップデート可能かどうか
    var isUpdatable: Bool {
        if isNextPayable && isSatisfyRequirement &&
            (upgradeStatus.level + 1) <= upgradeStatus.upgradeRange.upperBound {
            return true
        } else {
            return false
        }
    }
    //現在の所持金で支払いできるかどうか
    var isNextPayable: Bool {
        guard let upgradeViewModel = parentModel else {
            return false
        }
        let cost = upgradeStatus.initialCost * Int(pow(Double(10), Double(upgradeStatus.level + 1)))
        return cost <= upgradeViewModel.money
    }
    //解放に必要な前提条件を満たしているかどうか
    var isSatisfyRequirement: Bool {
        guard let upgradeViewModel = parentModel else {
            return false
        }
        if upgradeStatus.requiredUnlock.isEmpty {
            return true
        }
        //それぞれのUnlockに必要な情報を一つずつ取り出し、itemsの配列と照らし合わせる
        let isSatisfyed: [Bool] = upgradeStatus.requiredUnlock
            .map { flag in
                let requiredItem = upgradeViewModel.upgradeItems.first{
                    $0.upgradeStatus.type == flag.type
                }!
                return requiredItem.upgradeStatus.level >= flag.levelNeeds
            }
        return isSatisfyed.allSatisfy{ $0 }
    }
}

struct UpgradeItemModel {
    init(type: UpgradeType) {
        self.type = type
    }
    let type:UpgradeType
    var level: Int = 0
    
    var text: String {
        switch type {
        case .life:
            return "life"
        case .inventory:
            return "inventory"
        case .triforceCost:
            return "triforceCost"
        case .triforceDrop:
            return "triforceDrop"
        case .withKeyTriforceUnlock:
            return "withKyeTriforceUnlock"
        }
    }
    ///UpGrade可能な範囲を返す
    var upgradeRange: ClosedRange<Int> {
        switch type {
        case .life:
            return  1...10
        case .inventory:
            return  1...10
        case .triforceCost:
            return 1...5
        case .triforceDrop:
            return 1...10
        case .withKeyTriforceUnlock:
            return 0...1
        }
    }
    ///UpGrade解放に必要なステージ数
    var stageFlag: Int {
        switch type {
        case .life:
            return 1
        case .inventory:
            return 1
        case .triforceCost:
            return 4
        case .triforceDrop:
            return 4
        case .withKeyTriforceUnlock:
            return 8
        }
    }
    ///UpGrade解放に必要なフラグ、tupleの第一引数で条件になっている強化の種類を、第二引数で必要な強化段階を表す
    var requiredUnlock: [(type:UpgradeType,levelNeeds: Int)] {
        switch type {
        case .life:
            return []
        case .inventory:
            return []
        case .triforceCost:
            return []
        case .triforceDrop:
            return []
            // TODO: View側の実装
        case .withKeyTriforceUnlock:
            return [(.triforceCost, 1)]
        }
    }
    ///基本となる強化費用
    var initialCost: Int {
        switch type {
        case .life:
            return 10
        case .inventory:
            return 10
        case .triforceCost:
            return 10
        case .triforceDrop:
            return 10
        case .withKeyTriforceUnlock:
            return 1000
        }
    }
}

enum UpgradeType: CaseIterable{
    case life
    case inventory
    case triforceCost
    case triforceDrop
    case withKeyTriforceUnlock
}


