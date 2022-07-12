//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///
struct ActionItemModel: Identifiable, Hashable {
    let type: ActionType
    let level: Int
    init(type: ActionType, level: Int) {
        self.type = type
        self.level = level
        self.count = defaultCount
    }
    var count: Int = 0
    let id = UUID()
    var cost: Int? {
        switch self.type {
            
        case .normal:
            return nil
        case .pyramid:
            switch level {
            case 0:
                return nil
            case 1...3:
                return 9 - level
            default:
                fatalError("想定外のレベル")
            }
        case .hexagon:
            switch level {
            case 0:
                return nil
            case 1...3:
                return 13 - level
            default:
                fatalError("想定外のレベル")
            }
        case .hexagram:
            switch level {
            case 0:
                return nil
            case 1...3:
                return 20 - level
            default:
                fatalError("想定外のレベル")
            }
        }
    }
    private var defaultCount: Int {
        switch type {
        case .normal:
            return level + 2
        case .pyramid:
            return 0
        case .hexagon:
            return 0
        case .hexagram:
            return 0
        }
    }
}

enum ActionType: CaseIterable {
    case normal
    case pyramid
    case hexagon
    case hexagram
    ///基準の座標からOnにする座標を示す
    ///外側の配列が順番を、内側の座標がtriangleの座標を表す
    var actionCoordinate:[[(Int,Int)]] {
        switch self {
            
        case .normal:
            return [
                [(0, 0)]
            ]
        case .pyramid:
            return [
                [(0, 0)],
                [(-1, 0), (1, -1), (1, 0)]
            ]
        case .hexagon:
            return [
                [(0, 0), (-1, 0), (-2, 0), (1,-1), (0, -1), (-1, -1)]
            ]
        case .hexagram:
            return [
                [(0, 0), (-1, 0), (-2, 0), (1,-1), (0, -1), (-1, -1)],
                [(-3, 0), (1, 0), (1, -2), (-2, 1), (-2, -1), (2, -1)]
            ]
        }
    }
    
    ///タップする起点を表す
    var position: Position {
        switch self {
            
        case .normal:
            return .center
        case .pyramid:
            return .center
        case .hexagon:
            return .vertex
        case .hexagram:
            return .vertex
        }
    }
    
   
    var upgradeItem: UpgradeType? {
        switch self {
        case .normal:
            return .normal
        case .pyramid:
            return .pyramid
        case .hexagon:
            return .hexagon
        case .hexagram:
            return .hxagram
        }
    }
    
}

enum Position {
    case center
    case vertex
}

///面タップ時の描画のモデル
struct ActionEffectViewModel: Identifiable{
    let action: ActionType
    let coordinate: StageCoordinate
    let id = UUID()
}