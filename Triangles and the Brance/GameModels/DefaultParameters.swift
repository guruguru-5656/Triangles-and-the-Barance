//
//  DefaultParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import Foundation

//Gameをリセットしてもクリアされないパラメーター
struct DefaultParameters {
    

//    var actionItemData: [ActionItemData] = ActionType.allCases.map{
//        ActionItemData(type: $0)
//    }
//
//    //タイプで変更箇所を指定し、levelを書き換える
//    mutating func setActionItemLevel(type: ActionType, level: Int) {
//        guard let index = actionItemData.firstIndex(where: { $0.type == type })
//        else {
//            print("アクションアイテム指定エラー")
//            return
//        }
//        actionItemData[index].upGradelevel = level
//    }
}
//
//struct ActionItemData {
//    let type: ActionType
//    var upGradelevel = 0
//    var cost: Int? {
//        guard let defaultCost = type.defaultCost else {
//            return nil
//        }
//        return defaultCost - upGradelevel
//    }
//}
