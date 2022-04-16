//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

struct ActionItemModel:Identifiable,Hashable{
    let action: ActionType
    let id:UUID = UUID()
    
    init(action: ActionType) {
        self.action = action
    }
  
    ///アクションごとにステージ内の書き換えを行う場所を返す
    func actionCoordinate(reversed: Bool) -> [(Int,Int)] {
        switch action {
            
        case .normal:
            return [(0,0)]
        case .triforce:
            switch reversed {
                
            case false:
                return [(0,0), (-1, 0), (1, -1), (1, 0)]
            case true:
                return [(0,0), (-1, 0), (1, 0), (-1, 1)]
            }
        }
    }
}

enum ActionType:CaseIterable{
    case normal
    case triforce
    ///生成にかかるコスト
    var defaultCost: Int?{
        switch self{
        case .triforce:
            return 8
        case .normal:
            return nil
        }
    }
    
}
