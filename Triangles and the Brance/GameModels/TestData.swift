//
//  TestData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation

//検証用にデータを定数で読みこむクラス
final class TestData {
    //テスト用データ
    private func gameStatusValue(type: StageState) -> Int {
        switch type {
        case .stage:
            return 12
        }
    }
    
    private func upgradeDataValue(type: UpgradeType) -> Int {
        switch type {
        case .life:
            return 6
        case .recycle:
            return 5
        case .hourGlass:
            return 3
        case .triHexagon:
            return 3
        case .pyramid:
            return 3
        case .shuriken:
            return 3
        case .hexagon:
            return 3
        case .horizon:
            return  2
        case .hexagram:
            return 1
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
        case .point:
            return 0
        case .totalPoint:
            return  100000
        }
    }
    //キャッシュ
    private var casheData: [String:Int] = [:]
}

extension TestData: DataClass {
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
        case is StageState:
            return gameStatusValue(type: name as! StageState)
        default:
            fatalError("型指定エラー")
        }
    }
    
    func saveData<T: SaveDataName>(name: T, intValue: Int) {
        casheData.updateValue(intValue, forKey: name.description)
    }
    
    func loadData<T, U>(name: T, valueType: U.Type) -> Optional<U> where T : SaveDataName, U : Decodable, U : Encodable {
        switch name.self {
        case is StageLogs:
            return [StageLog]() as? U
        default:
            return nil
        }
    }
    
    func saveData<T, U>(name: T, value: U) where T : SaveDataName, U : Decodable, U : Encodable {
        return
    }
}
