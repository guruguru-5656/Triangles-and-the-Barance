//
//  SaveDataStore.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/09.
//

import Foundation


final class TutrialData {

    private func upgradeDataValue(type: UpgradeType) -> Int {
        switch type {
        case .life:
            return 1
        case .recycle:
            return 1
        case .hourGlass:
            return 1
        case .triHexagon:
            return 0
        case .pyramid:
            return 0
        case .shuriken:
            return 0
        case .hexagon:
            return 0
        case .horizon:
            return  0
        case .hexagram:
            return 0
        }
    }
    
    private func scoreDataValue(type: ResultValue) -> Int {
        switch type {
        case .stage:
            return 0
        case .count:
            return 0
        case .combo:
            return 0
        case .score:
            return 0
        case .totalPoint:
            return  0
        }
    }
    private var stageLife: Int {
        upgradeDataValue(type: .life) + 5
    }
    private lazy var stageStatus = StageStatus(stage: 1, life: stageLife)
    private var stageScore = StageScore(stage: 1, score: 0, count: 0, combo: 0)
    //キャッシュ
    private var casheData: [String:Int] = [:]
}

extension TutrialData: DataClass {
    //キャッシュがあればそれをロードし、なければテスト用データをロードする
    func loadData<T:SaveDataName>(name: T) -> Int {
        if let data = casheData[name.description] {
            return data
        }
        switch name.self {
        case is UpgradeType:
            return upgradeDataValue(type: name as! UpgradeType)
        case is ResultValue:
            return scoreDataValue(type: name as! ResultValue)
        default:
            fatalError("型指定エラー")
        }
    }
    
    func saveData<T: SaveDataName>(name: T, intValue: Int) {
        casheData.updateValue(intValue, forKey: name.description)
    }
    
    func loadData<T: Codable>(type: T.Type) -> Optional<T> {
        switch type {
        case is StageScore.Type:
            return stageScore as? T
        case is StageStatus.Type:
            return stageStatus as? T
        default:
            return nil
        }
    }
    
    func saveData<T: Codable>(value: T) {
        switch value {
        case is StageScore:
            self.stageScore = value as! StageScore
        default: return
        }
    }
    
    //現状取り除く必要がないため、何も行わない
    func removeData<T:SaveDataName>(name: T) { }
    func removeData<T: Codable>(value: T.Type) { }
}
