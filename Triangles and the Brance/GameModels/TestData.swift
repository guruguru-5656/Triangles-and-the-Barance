//
//  TestData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation

//検証用にデータを定数で読みこむクラス
final class TestData: DataClass {
    //テスト用データ
    private struct UpgradeData {
        let type: UpgradeType
        var value: Int {
            switch type {
            case .life:
                return 1
            case .recycle:
                return 1
            case .actionCount:
                return 1
            case .pyramid:
                return 1
            case .shuriken:
                return 1
            case .hexagon:
                return 1
            case .horizon:
               return  1
            case .hxagram:
                return 1
            }
        }
    }
    
    private struct ScoreData {
        let type: ScoreType
        var value: Int {
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
               return  0
            }
        }
    }
    
    private struct GameStatusData {
        let type: GameStatus
        var value: Int {
            switch type {
            case .stage:
               return 1
            case .deleteCount:
               return 0
            case .life:
               return 3
            case .point:
               return  3
            }
        }
    }
    //キャッシュ
    private var casheData: [String:Int] = [:]
    //キャッシュがあればそれをロードし、なければテスト用データをロードする
    func loadData<T:SaveDataName>(name: T) -> Int {
        if let data = casheData[name.description] {
            return data
        }
        switch name.self {
        case is UpgradeType:
            return UpgradeData(type: name as! UpgradeType).value
        case is ScoreType:
            return ScoreData(type: name as! ScoreType).value
        case is GameStatus:
            return GameStatusData(type: name as! GameStatus).value
        default:
            fatalError("型指定エラー")
        }
    }
    func saveData<T: SaveDataName>(name: T, intValue: Int) {
        casheData.updateValue(intValue, forKey: name.description)
    }
    func loadData<T, U>(name: T, valueType: U.Type) -> Optional<U> where T : SaveDataName, U : Decodable, U : Encodable {
        return nil
    }
    
    func saveData<T, U>(name: T, value: U) where T : SaveDataName, U : Decodable, U : Encodable {
        return
    }
}
