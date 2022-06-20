//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///
struct ActionItem: Identifiable, Hashable {
    let action: ActionType
    let id = UUID()
}

enum ActionType: CaseIterable {
    case normal
    case pyramid
    
    ///基準の座標からOnにする座標を示す
    ///外側の配列が順番を、内側の座標がtriangleの座標を表す
    var actionCoordinate:[[(Int,Int)]] {
        switch self {
            
        case .normal:
                return [[(0,0)]]
        case .pyramid:
                return [[(0,0)],
                        [(-1, 0), (1, -1), (1, 0)]]
        }
    }
    
    ///タップする起点を表す
    var position: Position {
        switch self {
            
        case .normal:
            return Position.face
        case .pyramid:
            return Position.face
        }
    }
    
    var defaultCost: Int? {
        switch self {
        case .normal:
            return nil
        case .pyramid:
            return 8
        }
    }
    var upgradeItem: UpgradeType? {
        switch self {
        case .normal:
            return nil
        case .pyramid:
            return .pyramid
        }
    }
    
}

enum Position {
    case face
    case vertex
}

///面タップ時の描画のモデル
struct FaceTapActionItemProgressModel {
    let action: ActionType
    let coordinate: ModelCoordinate
}

///頂点タップ時の描画のモデル
struct vetexTapActionItemProgressModel {
    let action: ActionType
    let coordinate: TriVertexCoordinate
}
