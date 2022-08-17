//
//  StageStatus.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/14.
//

import Foundation



enum GameStatus: SaveDataValue {
    
    case stage
    case deleteCount
    case life
    case point
    
    var defaultValue: Int {
        switch self {
        case .stage:
            return 1
        default:
            return 0
        }
    }
}

struct StageLog {
    let stage: Int
    let deleteCount: Int
    let maxCombo: Int
}
