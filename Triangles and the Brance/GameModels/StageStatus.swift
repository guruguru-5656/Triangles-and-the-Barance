//
//  StageStatus.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/25.
//

import Foundation


struct StageStatus:Codable, Hashable {
    let stage: Int
    var deleteCount: [Int] = []
    var maxCombo: Int = 0
    var energy: Int = 0
    var life: Int
    
    var targetDeleteCount: Int {
        StageStatus.targetList[stage - 1]
    }
    
    var totalDeleteCount: Int {
        deleteCount.reduce(0, +)
    }
    
    var clearRate: Double {
        Double(totalDeleteCount) / Double(targetDeleteCount) > 1 ? 1 : Double(totalDeleteCount) / Double(targetDeleteCount)
    }
    
    var score: Int {
        deleteCount.reduce(0) {
            $0 + Calculation.individualScore($1)
        }
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
        if maxCombo < count {
            maxCombo = count
        }
        deleteCount.append(count)

        //イベントの判定
        if self.deleteCount.reduce(0 , +) >= targetDeleteCount {
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
        case stageClear, gameOver , gameClear
    }
}


extension StageStatus {
    static private let targetList = [10, 15, 20, 25, 30, 36, 43, 50, 57, 63, 70, 80]
}
