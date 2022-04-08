//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import Foundation

struct ActionItemViewModel:Identifiable,Hashable{
    let action: ActionType
    let id:UUID = UUID()
    var status: ViewStatus
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
    ///アクションごとにステージ内の書き換えを行う場所を返す
    func actionCoordinate(from coordinate:ModelCoordinate) ->Set<ModelCoordinate>{
        switch self{
        case .normal:
            return []
        case .triforce:
            let coordinates: Set<ModelCoordinate>
            let remainder = coordinate.x % 2
             if remainder == 0{
                 coordinates = ([
                    ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                    ModelCoordinate(x:coordinate.x+1, y:coordinate.y-1),
                    ModelCoordinate(x:coordinate.x+1, y:coordinate.y),])
             }else{
                 coordinates = ([
                    ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                    ModelCoordinate(x:coordinate.x+1, y:coordinate.y),
                    ModelCoordinate(x:coordinate.x-1, y:coordinate.y+1),])
             }
             return coordinates
        }
    }
}
