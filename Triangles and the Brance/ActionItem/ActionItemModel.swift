//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

struct ActionItemModel: Hashable, Identifiable {
    
    let type: ActionType
    let level: Int
    let id = UUID()
    
    init(type: ActionType, level: Int) {
        self.type = type
        self.level = level
    }
    
    var cost: Int {
        if let upgradeType = upgradeType {
            return upgradeType.effect(level: level)
        }
        return 0
    }
    
    private var upgradeType: UpgradeType? {
        switch self.type {
        case .normal:
             return  nil
        case .hourGlass:
            return .hourGlass
        case .triHexagon:
            return .triHexagon
        case .pyramid:
            return  .pyramid
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
    
    private var defaultCost: Int? {
        switch self.type {
        case .normal:
            return 0
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
}

enum ActionType: String, CaseIterable {
    case normal
    case hourGlass
    case triHexagon
    case pyramid
    case shuriken
    case hexagon
    case horizon
    case hexagram
    ///基準の座標からOnにする座標を示す
    ///外側の配列が順番を、内側の座標がtriangleの座標を表す
    var actionCoordinate:[[(Int,Int)]] {
        switch self {
            
        case .normal:
            return [
                [(0, 0)]
            ]
        case .hourGlass:
            return [
                [(0, 0)],
                [(1, -1)]
            ]
        case .triHexagon:
            return [
                [(0, 0), (-2, 0), (0, -1), ]
            ]
        case .pyramid:
            return [
                [(0, 0)],
                [(-1, 0), (1, -1), (1, 0)]
            ]
        case .shuriken:
            return [
            [(0, 0)],
            [(-1, 0), (1, -1), (1, 0)],
            [(2, -1), (0, 1), (-2, 0)]
            ]
        case .hexagon:
            return [
                [(0, 0), (-1, 0), (-2, 0), (1,-1), (0, -1), (-1, -1)]
            ]
        case .horizon:
            return [
                [(0, 0)],
                [(-1, 0), (1, 0)],
                [(-2, 0), (2, 0)],
                [(-3, 0), (3, 0)],
                [(-4, 0), (4, 0)],
                [(-5, 0), (5, 0)],
                [(-6, 0), (6, 0)],
                [(-7, 0), (7, 0)],
                [(-8, 0), (8, 0)],
                [(-9, 0), (9, 0)],
                [(-10, 0), (10, 0)]
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
        case .hourGlass:
            return .center
        case .triHexagon:
            return .vertex
        case .pyramid:
            return .center
        case .shuriken:
            return .center
        case .hexagon:
            return .vertex
        case .horizon:
            return .center
        case .hexagram:
            return .vertex
        }
    }
    
    ///効果を及ぼす座標を返す
    func itemEffectCoordinates<T: StageCoordinate>(coordinate: T) -> [[TriangleCenterCoordinate]] {
        //入力された座標がitemのpositionと一致するかチェック
        guard coordinate.position == self.position else{
            return []
        }
        return coordinate.relative(coordinates: actionCoordinate)
    }
}

enum Position {
    case center
    case vertex
}

///エフェクトのモデル
struct ActionEffectViewModel: Identifiable{
    let action: ActionType
    let coordinate: StageCoordinate
    let id = UUID()
}
