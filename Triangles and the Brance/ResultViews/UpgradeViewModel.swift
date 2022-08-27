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
        parentModel.point -= cost
        parentModel.payingPoint += cost
        level += 1
    }
    ///10のレベル乗をinitialCostにかける
    var cost: Int {
        initialCost * (level + 1) * (level + 1)
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
        
        return cost <= upgradeViewModel.point
    }
    
    var descriptionText: String {
        if level == 0 &&  type.actionType != nil {
            return ""
        }
        switch type {
        case .life:
            return "回数"
        case .recycle:
            return "確率"
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
        case .hxagram:
            return "コスト"
        }
    }
    var currentEffect: String {
        if level == 0 &&  type.actionType != nil {
            return ""
        }
        switch type {
        case .life:
            return "\(level + 2)"
        case .recycle:
            return "\(level * 20)%"
        case .actionCount:
            return "\(level + 2)"
        case .pyramid:
            return "\(7 - level)"
        case .shuriken:
            return "\(9 - level)"
        case .hexagon:
            return "\(11 - level)"
        case .horizon:
            return "\(15 - level)"
        case .hxagram:
            return "\(17 - level)"
        }
        
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
        case .hxagram:
            return Image("hexagram")
       
        }
        
    }
    ///基本となる強化費用
    private var initialCost: Int {
        switch type {
        case .life:
            return 100
        case .recycle:
            return 50
        case .actionCount:
            return 100
        case .pyramid:
            return 50
        case .shuriken:
            return 400
        case .hexagon:
            return 1000
        case .horizon:
            return 3000
        case .hxagram:
            return 5000
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
    case hxagram
    ///UpGrade可能な範囲を返す
    var upgradeRange: ClosedRange<Int> {
        switch self {
        case .life:
            return  0...5
        case .recycle:
            return  0...3
        case .actionCount:
            return 0...3
        case .pyramid:
            return 0...3
        case .shuriken:
            return 0...3
        case .hexagon:
            return 0...3
        case .horizon:
            return 0...3
        case .hxagram:
            return 0...3
       
        }
    }
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
            self = .hxagram
        }
    }
    var actionType: ActionType? {
        switch self {
        case .life:
            return nil
        case .recycle:
            return nil
        case .actionCount:
            return .normal
        case .pyramid:
            return .pyramid
        case .shuriken:
            return .shuriken
        case .hexagon:
            return .hexagon
        case .horizon:
            return .horizon
        case .hxagram:
            return .hexagram
        }
    }
}




