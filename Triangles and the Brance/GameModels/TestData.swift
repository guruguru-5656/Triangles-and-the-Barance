//
//  TestData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation

//検証用にデータを定数で読みこむクラス
final class TestData {
    static let startStage: Int = 5      // 1...12
    var upgradeData: [(type: UpgradeType, value: Int)] = [
        (type: .life, value: 1),        // 0...5
        (type: .recycle, value: 1),     // 0...3
        (type: .actionCount, value: 1), // 0...3
        (type: .pyramid, value: 1),     // 0...3
        (type: .shuriken, value: 1),    // 0...3
        (type: .hexagon, value: 1),     // 0...3
        (type: .horizon, value: 1),     // 0...3
        (type: .hxagram, value: 1),     // 0...3
    ]

    var scoreData: [(type: ScoreType, value: Int)] = [
        (type: .stage, value: 0),
        (type: .count, value: 0),
        (type: .combo, value: 0),
        (type: .score, value: 0)
    ]
    
    var point: Int = 0
    
//    func loadData<T:SaveDataType>(type: T) -> Int {
//        switch type.self {
//        case is UpgradeType:
//            return upgradeData.first {
//                $0.type == type as! UpgradeType
//            }!.value
//        case is ScoreType:
//            return scoreData.first {
//                $0.type == type as! ScoreType
//            }!.value
//        case is PointType:
//            return point
//        default:
//            fatalError("想定外のタイプ指定")
//        }
//    }
//    
//    func saveData<T: SaveDataType>(type: T, value: Int) {
//        switch type.self {
//        case is UpgradeType:
//            let index = upgradeData.firstIndex {
//                $0.type == type as! UpgradeType
//            }!
//            upgradeData[index].value = value
//        case is PointType:
//            point = value
//        default:
//            fatalError("想定外のタイプ指定")
//        }
//    }
}

