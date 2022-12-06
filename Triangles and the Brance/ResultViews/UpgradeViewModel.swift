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
    private let soundPlayer = SEPlayer.shared
    
    init() {
        upgradeItems = loadUpgradeData()
        point = SaveData.shared.loadData(name: ResultValue.totalPoint)
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
  
    func cancel() {
        point += payingPoint
        payingPoint = 0
        soundPlayer.play(sound: .cancelSound)
    }
    
    func permitPaying() {
        upgradeItems.forEach {
            SaveData.shared.saveData(name: $0.type, intValue: $0.level)
        }
        SaveData.shared.saveData(name: ResultValue.totalPoint, intValue: point)
        soundPlayer.play(sound: .decideSound)
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
struct UpgradeCellViewModel: Identifiable {

   
    let type:UpgradeType
    var level: Int
    var text: String {
        String(describing: type)
    }
    let id = UUID()
    //親クラスの参照
    fileprivate weak var parentModel: UpgradeViewModel?
    private let soundPlayer = SEPlayer.shared
   //upgradeできる状態か確認し実行する
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
    //説明画面を開く
    func showDetail() {
        parentModel?.showDetail(self)
    }
    
    func playUpgradeSound() {
        soundPlayer.play(sound: .decideSound)
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
    
    var effectDescriptionText: String {
        if level == 0 &&  type.actionType != nil {
            return "Locked"
        }
        switch type {
        case .life:
            return "回数"
        case .recycle:
            return "割合(%)"
        case .hourGlass:
            return "コスト"
        case .triHexagon:
            return "コスト"
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
    
    var descriptionText: String? {
        switch type {
        case .life:
            return "操作できる回数"
        case .recycle:
            return "消した三角の" + currentEffect + "%がフィールド上に復活する"
        case .hourGlass:
            return nil
        case .triHexagon:
            return nil
        case .pyramid:
            return nil
        case .shuriken:
            return nil
        case .hexagon:
            return nil
        case .horizon:
            return nil
        case .hexagram:
            return nil
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
        case .hourGlass:
            return Image("hourGlass")
        case .triHexagon:
            return Image("triHexagon")
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

enum UpgradeType: Int, CaseIterable, SaveDataName {
   
    case life
    case recycle
    case hourGlass
    case triHexagon
    case pyramid
    case shuriken
    case hexagon
    case horizon
    case hexagram
  
    init?(actionType: ActionType) {
        switch actionType {
        case .normal:
            return nil
        case .hourGlass:
            self = .hourGlass
        case .triHexagon:
            self = .triHexagon
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
        case .hourGlass:
            return .hourGlass
        case .triHexagon:
            return .triHexagon
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
            return level + 5
        case .recycle:
            return level * 10
        case .hourGlass:
            return 5 - level
        case .triHexagon:
            return 7 - level
        case .pyramid:
            return 9 - level
        case .shuriken:
            return 13 - level
        case .hexagon:
            return 13 - level
        case .horizon:
            return 16 - level
        case .hexagram:
            return 21 - level
        }
    }
    ///強化費用
    var costList: [Int] {
        switch self {
        case .life:
            return [100, 400, 1000, 3000, 5000, 10000, 15000]
        case .recycle:
            return [50, 100, 300, 800, 2000]
        case .hourGlass:
            return [50, 75, 100]
        case .triHexagon:
            return [100, 150, 200]
        case .pyramid:
            return [400, 600, 800]
        case .shuriken:
            return [1000, 1500, 2000]
        case .hexagon:
            return [3000, 3500, 4000]
        case .horizon:
            return [5000, 6000, 7000]
        case .hexagram:
            return [10000]
        }
    }
}
