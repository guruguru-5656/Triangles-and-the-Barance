//
//  SaveDataValue.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation


extension UpgradeType {
    var testValue: Int {
        switch self {
        case .life:
            return 0
        case .recycle:
            return 0
        case .actionCount:
            return 0
        case .pyramid:
            return 0
        case .shuriken:
            return 0
        case .hexagon:
            return 0
        case .horizon:
            return 0
        case .hxagram:
            return 0
        }
    }
}

extension ScoreType {
    var testValue: Int {
        switch self {
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
            return 0
        }
    }
}

extension GameStatus {
    var testValue: Int {
        switch self {
        case .stage:
            return 1
        case .deleteCount:
            return 0
        case .life:
            return 0
        case .point:
            return 0
        }
    }

}
