//
//  StageStatus.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/25.
//

import Foundation


struct StageStatus: Codable, Hashable {
    let stage: Int
    var deleteCount: Int = 0
    var energy: Int = 0
    var life: Int
    
    var targetDeleteCount: Int {
        StageStatus.targetList[stage - 1]
    }
  
    var clearRate: Double {
        Double(deleteCount) / Double(targetDeleteCount) > 1 ? 1 : Double(deleteCount) / Double(targetDeleteCount)
    }
    
    func canUseItem(cost: Int) -> Bool{
        return  cost <= energy && life > 1
    }
    
    mutating func useItem(item: ActionItemModel) {
        life -= 1
        energy -= item.cost
    }
    
    mutating func triangleDidDeleted(count: Int) -> StageEvent? {
        energy += count
        life -= 1
        deleteCount += count

        //イベントの判定
        if self.deleteCount >= targetDeleteCount {
            if stage == 12 {
                return .gameClear
            }
            return .stageClear
        }
        if life == 0 {
            return .gameOver
        }
        return nil
    }
    
    enum StageEvent {
        case stageClear, gameOver, gameClear
    }
}


extension StageStatus {
    static private let targetList = [8, 12, 17, 22, 27, 33, 40, 47, 55, 63, 70, 80]
}
