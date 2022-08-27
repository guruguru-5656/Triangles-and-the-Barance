//
//  StageStatus.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/14.
//

import Foundation



enum GameStatus: SaveDataName {
    case stage
    case deleteCount
    case life
    case point
}

enum GameLog: SaveDataName {
    case log
}


struct StageData:Codable {
    let stage: Int
    let deleteCount: Int
    let maxCombo: Int
}
