//
//  UpGradeModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import SwiftUI

class UpgradeViewModel: ObservableObject {
    @Published var upgradeItems: [UpgradeCellViewModel] = []
    @Published var point: Int = 0
    @Published var payingPoint = 0
    @Published var detailItem = UpgradeCellViewModel(type: .life, level: 0)
    @Published var showDetailView = false
    
    init() {
        upgradeItems = loadUpgradeData()
        point = loadTotalPointData()
        upgradeItems.indices.forEach{
            upgradeItems[$0].parentModel = self
        }
    }
    
    func loadUpgradeData() -> [UpgradeCellViewModel] {
        UpgradeType.allCases.map { type -> UpgradeCellViewModel in
            let level = SaveData.shared.loadData(name: type)
            return UpgradeCellViewModel(type: type, level: level)
        }
    }
    
    func loadTotalPointData() -> Int {
        SaveData.shared.loadData(name: ResultValue.totalPoint)
    }
  
    func cancel() {
        point += payingPoint
        payingPoint = 0
    }
    
    func permitPaying() {
        upgradeItems.forEach {
            SaveData.shared.saveData(name: $0.type, value: $0.level)
        }
        SaveData.shared.saveData(name: ResultValue.totalPoint, value: point)
    }
    
    func showDetail(_ item: UpgradeCellViewModel) {
        if showDetailView {
            withAnimation {
                showDetailView = false
            }
        } else {
            detailItem = item
            withAnimation {
                showDetailView = true
            }
        }
    }
    
    func closeDetail() {
        withAnimation {
            showDetailView = false
        }
    }
}

//UpgradeSubViewのモデル
struct UpgradeCellViewModel: Identifiable{
    
    let type:UpgradeType
    var level: Int
    var text: String {
        String(describing: type)
    }
    let id = UUID()
    //親クラスの参照
    fileprivate weak var parentModel: UpgradeViewModel?
   
    mutating func upgrade(){
        guard let parentModel = parentModel else {
            return
        }
        guard isUpdatable else {
            return
        }
        parentModel.point -= cost!
        parentModel.payingPoint += cost!
        level += 1
    }
    
    private var cost: Int? {
        guard type.costList.indices.contains(level) else {
            return nil
        }
        return type.costList[level]
    }
    //アップデート可能かどうか
    var isUpdatable: Bool {
       isNextPayable && (level + 1) <= type.costList.count
    }
    //現在の所持金で支払いできるかどうか
    private var isNextPayable: Bool {
        guard let upgradeViewModel = parentModel else {
            return false
        }
        guard let cost = cost else {
            return false
        }
        return cost <= upgradeViewModel.point
    }
    
    var costText: String {
        if let cost = cost {
            return String(format: "%6d", cost)
        } else {
            return "   Max"
        }
    }
    
    var descriptionText: String {
        if level == 0 &&  type.actionType != nil {
            return "Locked"
        }
        switch type {
        case .life:
            return "回数"
        case .recycle:
            return "割合(%)"
        case .actionCount:
            return "回数"
        case .pyramid:
            return "コスト"
        case .shuriken:
            return "コスト"
        case .hexagon:
            return "コスト"
        case .horizon:
            return "コスト"
        case .hexagram:
            return "コスト"
        }
    }
    var currentEffect: String {
        if level == 0 && type.actionType != nil {
            return ""
        }
        return String(type.effect(level: level))
    }
    var icon: Image {
        switch type {
        case .life:
            return Image(systemName: "heart")
        case .recycle:
            return Image("recycle")
        case .actionCount:
            return Image("normalTriangle")
        case .pyramid:
            return Image("pyramidTriangle")
        case .shuriken:
            return Image("shuriken")
        case .hexagon:
            return Image("hexagon")
        case .horizon:
            return Image("horizonTriangle")
        case .hexagram:
            return Image("hexagram")
        }
    }
}

enum UpgradeType: Int, CaseIterable , SaveDataName {
   
    case life
    case recycle
    case actionCount
    case pyramid
    case shuriken
    case hexagon
    case horizon
    case hexagram
  
    init?(actionType: ActionType) {
        switch actionType {
        case .normal:
            return nil
        case .pyramid:
            self = .pyramid
        case .shuriken:
            self = .shuriken
        case .hexagon:
            self = .hexagon
        case .horizon:
            self = .horizon
        case .hexagram:
            self = .hexagram
        }
    }
    
    var actionType: ActionType? {
        switch self {
        case .life:
            return nil
        case .recycle:
            return nil
        case .actionCount:
            return nil
        case .pyramid:
            return .pyramid
        case .shuriken:
            return .shuriken
        case .hexagon:
            return .hexagon
        case .horizon:
            return .horizon
        case .hexagram:
            return .hexagram
        }
    }
    
    func effect(level:Int) -> Int {
        switch self {
        case .life:
            return level + 2
        case .recycle:
            return level * 10
        case .actionCount:
            return level + 2
        case .pyramid:
            return 9 - level
        case .shuriken:
            return 11 - level
        case .hexagon:
            return 12 - level
        case .horizon:
            return 14 - level
        case .hexagram:
            return 17 - level
        }
    }
    ///強化費用
    var costList: [Int] {
        switch self {
        case .life:
            return [100, 1000, 5000, 10000]
        case .recycle:
            return [50, 100, 200, 400, 1000]
        case .actionCount:
            return [100, 500, 2000, 5000, 10000]
        case .pyramid:
            return [20, 50, 200, 500, 1000]
        case .shuriken:
            return [400, 600, 800, 1000, 1500]
        case .hexagon:
            return [600, 800, 1000, 1500, 2000]
        case .horizon:
            return [1000, 1500, 2000]
        case .hexagram:
            return [2000, 3000, 4000]
        }
    }
}
