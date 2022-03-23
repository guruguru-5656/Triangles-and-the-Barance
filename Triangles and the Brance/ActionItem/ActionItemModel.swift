//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import Foundation

struct ActionItemModel:Identifiable,Hashable{
    let action: ActionType
    let id:UUID = UUID()
    
}

enum ActionType:CaseIterable{
    case triforce
    
    ///生成にかかるコスト
    var cost: Int?{
        switch self{
        case .triforce:
            return 8
        }
    }
    
    ///アクションごとにステージ内の書き換えを行う場所を返す
    func actionCoordinate(from coordinate:ModelCoordinate) ->Set<ModelCoordinate>{
        
        switch self{
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
