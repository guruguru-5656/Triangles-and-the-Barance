//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import Foundation

struct ActionItemModel:Identifiable{
    let type: ActionType
    let id:UUID = UUID()
    
}

enum ActionType{
    case normal
    case triforce
}
