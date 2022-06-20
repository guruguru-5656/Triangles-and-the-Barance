//
//  UpGradeModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import SwiftUI

class UpgradeViewModel: ObservableObject {
    @Published var upgradeItems: [UpgradeItemModel]
    @Published var money: Int
    @Published var payingMoney = 0
    
    init(){
        upgradeItems = SaveData.shareData.upgradeItems
        money = SaveData.shareData.money
        upgradeItems.indices.forEach{
            upgradeItems[$0].parentModel = self
        }
    }
    func cancel() {
        money = SaveData.shareData.money
        payingMoney = 0
        withAnimation {
        GameModel.shared.score.showUpgrade = false
        }
    }
    func permitPaying() {
        SaveData.shareData.upgradeItems = upgradeItems
        SaveData.shareData.money = money
        GameModel.shared.score.money = money
        withAnimation {
        GameModel.shared.score.showUpgrade = false
        }
    }
}

//UpgradeSubViewのモデル
struct UpgradeItemModel: Identifiable{

    let type:UpgradeType
    var level: Int
    var text: String {
        String(describing: type)
    }
    let id = UUID()
    //親クラスの参照
    fileprivate weak var parentModel: UpgradeViewModel?
    //levelのデータを読み込まなかった場合のイニシャライザ
    init(type: UpgradeType) {
        self.type = type
        self.level = type.upgradeRange.lowerBound
    }
    
    init(type: String, level: Int64) {
        guard let upgradeType = UpgradeType.allCases.first (where: {String(describing: $0) == type})
        else {
            fatalError("UpgradeType指定エラー")
        }
        self.type = upgradeType
        self.level = Int(level)
    }
    mutating func upgrade(){
        guard let parentModel = parentModel else {
            return
        }
        parentModel.money -= cost
        parentModel.payingMoney += cost
        level += 1
    }
    ///10のレベル乗をinitialCostにかける
    var cost: Int {
        type.initialCost * Int(pow(Double(10), Double(level + 1)))
    }
    //アップデート可能かどうか
    var isUpdatable: Bool {
        if isNextPayable && isSatisfyRequirement &&
            (level + 1) <= type.upgradeRange.upperBound {
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
        let cost = type.initialCost * Int(pow(Double(10), Double(level + 1)))
        return cost <= upgradeViewModel.money
    }
    //解放に必要な前提条件を満たしているかどうか
    var isSatisfyRequirement: Bool {
        guard let upgradeViewModel = parentModel else {
            return false
        }
        if type.requiredUnlock.isEmpty {
            return true
        }
        //それぞれのUnlockに必要な情報を一つずつ取り出し、itemsの配列と照らし合わせる
        let isSatisfyed: [Bool] = type.requiredUnlock
            .map { flag in
                let requiredItem = upgradeViewModel.upgradeItems.first{
                    $0.type == flag.type
                }!
                return requiredItem.level >= flag.levelNeeds
            }
        return isSatisfyed.allSatisfy{ $0 }
    }
}

enum UpgradeType: Int, CaseIterable {
    case life
    case inventory
    case normalActionCount
    case pyramid
    case triforceDrop
    case withKeyTriforceUnlock
    ///UpGrade可能な範囲を返す
    var upgradeRange: ClosedRange<Int> {
        switch self {
        case .life:
            return  1...10
        case .inventory:
            return  1...10
        case .normalActionCount:
            return 1...5
        case .pyramid:
            return 1...5
        case .triforceDrop:
            return 1...10
        case .withKeyTriforceUnlock:
            return 0...1
       
        }
    }
    ///UpGrade解放に必要なステージ数
    var stageFlag: Int {
        switch self {
        case .life:
            return 1
        case .inventory:
            return 1
        case .normalActionCount:
            return 1
        case .pyramid:
            return 4
        case .triforceDrop:
            return 4
        case .withKeyTriforceUnlock:
            return 8
        }
    }
    ///UpGrade解放に必要なフラグ、tupleの第一引数で条件になっている強化の種類を、第二引数で必要な強化段階を表す
    var requiredUnlock: [(type:UpgradeType,levelNeeds: Int)] {
        switch self {
        case .life:
            return []
        case .inventory:
            return []
        case .normalActionCount:
            return []
        case .pyramid:
            return []
        case .triforceDrop:
            return []
            // TODO: Viewの実装
        case .withKeyTriforceUnlock:
            return [(.pyramid, 1)]
        
        }
    }
    ///基本となる強化費用
    var initialCost: Int {
        switch self {
        case .life:
            return 10
        case .inventory:
            return 10
        case .normalActionCount:
            return 10
        case .pyramid:
            return 10
        case .triforceDrop:
            return 10
        case .withKeyTriforceUnlock:
            return 1000
       
        }
    }
    
}




