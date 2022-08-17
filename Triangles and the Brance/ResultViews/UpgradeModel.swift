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
    @Published var point: Int = 0
    @Published var payingPoint = 0
    @Published var detailItem = UpgradeItemViewModel(type: .life)
    @Published var showDetailView = false
    
    init(){
        upgradeItems = SaveData.shareData.loadUpgradeData()
        //TODO: 修正
//        point = GameModel.shared.stageModel.totalPoint
        upgradeItems.indices.forEach{
            upgradeItems[$0].parentModel = self
        }
    }
    func cancel() {
        //TODO: 修正
        point
//        point = GameModel.shared.stageModel.totalPoint
        payingPoint = 0
        
    }
    func permitPaying() {
        SaveData.shareData.saveUpgradeData(model: upgradeItems)
        //TODO: 修正
//        GameModel.shared.stageModel.totalPoint = point
//        GameModel.shared.stageModel.saveData()
        GameModel.shared.score.totalPoint = point
    }
    
    func showDetail(_ item: UpgradeItemViewModel) {
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
struct UpgradeItemViewModel: Identifiable{
    
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

enum UpgradeType: Int, CaseIterable , SaveDataValue {
   
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
    
    var defaultValue: Int {
      return 0
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




