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
        upgradeItems = SaveData.shareData.loadUpgradeData()
        money = GameModel.shared.stageModel.money
        upgradeItems.indices.forEach{
            upgradeItems[$0].parentModel = self
        }
    }
    func cancel() {
        money = GameModel.shared.stageModel.money
        payingMoney = 0
        withAnimation {
            GameModel.shared.score.showUpgrade = false
        }
    }
    func permitPaying() {
        SaveData.shareData.saveUpgradeData(model: upgradeItems)
        GameModel.shared.stageModel.money = money
        GameModel.shared.stageModel.saveData()
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
        if isNextPayable &&
            (level + 1) <= type.upgradeRange.upperBound {
            return true
        } else {
            return false
        }
    }
    //現在の所持金で支払いできるかどうか
    private var isNextPayable: Bool {
        guard let upgradeViewModel = parentModel else {
            return false
        }
        let cost = type.initialCost * Int(pow(Double(10), Double(level + 1)))
        return cost <= upgradeViewModel.money
    }
    
    
    var descriptionImage: some View {
        return Image(systemName: "bag")
    }
    
    var descriptionText: String {
        switch type {
        case .life:
            return "回数"
        case .inventory:
            return "容量"
        case .normal:
            return "回数"
        case .pyramid:
            return "コスト"
        case .hexagon:
            return "コスト"
        case .hxagram:
            return "コスト"
        }
    }
    var currentEffect: String {
        switch type {
        case .life:
            return "\(level + 2)"
        case .inventory:
            return "\(level)"
        case .normal:
            return "\(level + 2)"
        case .pyramid:
            return "\(9 - level)"
        case .hexagon:
            return "\(13 - level)"
        case .hxagram:
            return "\(21 - level)"
        }
        
    }
    var icon: Image {
        switch type {
        case .life:
            return Image(systemName: "heart")
        case .inventory:
            return Image(systemName: "bag")
        case .normal:
            return Image("normalTriangle")
        case .pyramid:
            return Image("pyramidTriangle")
        case .hexagon:
            return Image("hexagon")
        case .hxagram:
            return Image("hexagram")
        }
        
    }
}

enum UpgradeType: Int, CaseIterable {
    case life
    case inventory
    case normal
    case pyramid
    case hexagon
    case hxagram
    ///UpGrade可能な範囲を返す
    var upgradeRange: ClosedRange<Int> {
        switch self {
        case .life:
            return  1...5
        case .inventory:
            return  1...5
        case .normal:
            return 1...5
        case .pyramid:
            return 0...3
        case .hexagon:
            return 0...3
        case .hxagram:
            return 0...3
        }
    }
   
    ///基本となる強化費用
    var initialCost: Int {
        switch self {
        case .life:
            return 10
        case .inventory:
            return 10
        case .normal:
            return 10
        case .pyramid:
            return 10
        case .hexagon:
            return 10
        case .hxagram:
            return 100
        }
    }
}




