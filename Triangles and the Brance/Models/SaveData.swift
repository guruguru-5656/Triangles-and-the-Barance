//
//  SaveData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation

//TODO: データベースとのやりとり
final class SaveData {
    private init() {
        //TODO: データベースからハイスコアを取得
        
        //存在しない場合は生成
        UpgradeType.allCases.forEach{
            upgradeItems.append(
                UpgradeItemModel(type: $0)
            )
        }
        hiScores = Score.allCases.map {
            HiScoreModel(type: $0)
        }
    }
    static let shareData = SaveData()
    
    var money:Int = 0
    var upgradeItems: [UpgradeItemModel] = []
    var hiScores: [HiScoreModel] = []
}

struct HiScoreModel {
    init(type: Score) {
        self.type = type
        if type == .stage {
            self.value = 1
        }
    }
    let type: Score
    var value: Int = 0
   
}
