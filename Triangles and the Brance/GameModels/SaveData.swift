//
//  SaveData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import CoreData


final class SaveData {
    
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container.viewContext
    }()
    var money:Int = 0 {
        didSet{
            saveMoneyData()
        }
    }
    var upgradeItems: [UpgradeItemModel] = [] {
        didSet{
            saveUpgradeData()
        }
    }
    var hiScores: [HiScoreModel] = [] {
        didSet{
            saveHiScoreData()
        }
    }
    
    static let shareData = SaveData()
    private init() {
        loadMoneyData()
        loadUpgradeData()
        loadHiScoreData()
    }
    
    func shareUpgradeData(type: UpgradeType) -> UpgradeItemModel {
        let data = upgradeItems.first {
            $0.type == type
        }
        guard let data = data else {
        fatalError("upgradeTypeに指定したデータが存在しない")
        }
        return data
    }
    
    private func saveHiScoreData() {
        let request = NSFetchRequest<HiScore>(entityName: "HiScore")
        guard let hiScoreData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        hiScores.forEach { hiScoreModel in
            if let hiScoreDataIndex = hiScoreData.firstIndex( where: {$0.type == String(describing: hiScoreModel.type)}){
                hiScoreData[hiScoreDataIndex].value = Int64(hiScoreModel.value)
            }else{
                let model = HiScore(context: context)
                model.type = String(describing: hiScoreModel.type)
                model.value = Int64(hiScoreModel.value)
                print("初回ハイスコア登録")
            }
        }
        do {
            try context.save()
        } catch {
            fatalError("Unable to Save Data")
        }
    }
    
    private func saveMoneyData() {
        let request = NSFetchRequest<MoneyModel>(entityName: "MoneyModel")
        guard let moneyData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        if moneyData.isEmpty  {
            let model = MoneyModel(context: context)
            model.value = Int64(money)
        } else {
            moneyData.first!.value = Int64(money)
        }
        do {
            try context.save()
        } catch {
            fatalError("Unable to Save Data")
        }
    }
    
    private func saveUpgradeData() {
        let request = NSFetchRequest<UpGrade>(entityName: "UpGrade")
        guard let fetchData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        upgradeItems.forEach { itemModel in
            if let upgradeIndex = fetchData.firstIndex( where: {$0.type == String(describing: itemModel.type)}){
                fetchData[upgradeIndex].level = Int64(itemModel.level)
            }else{
                let model = UpGrade(context: context)
                model.level = Int64(itemModel.level)
                model.type = String(describing: itemModel.type)
            }
        }
        do {
            try context.save()
        } catch {
            fatalError("Unable to Save Data")
        }
    }
    func saveUpgradeData(model: [UpgradeItemModel]) {
        let request = NSFetchRequest<UpGrade>(entityName: "UpGrade")
        guard let fetchData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        model.forEach { model in
            if let dataIndex = fetchData.firstIndex(where:{
                $0.type == String(describing: model.type)
            }) {
                fetchData[dataIndex].level = Int64(model.level)
            }        
        }
    }
    
    private func loadUpgradeData() {
        let request = NSFetchRequest<UpGrade>(entityName: "UpGrade")
        guard let loadData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        //データが存在する場合は取得存在しなければ生成
        UpgradeType.allCases.forEach{ type in
            if let loadData = loadData.first(where: {$0.type == String(describing: type)}) {
                upgradeItems.append(UpgradeItemModel(type: loadData.type!, level: loadData.level))
            }else{
                upgradeItems.append(UpgradeItemModel(type: type))
                let dataModel = UpGrade(context: context)
                dataModel.type = String(describing: type)
                dataModel.level = Int64(type.upgradeRange.lowerBound)
                do {
                    try context.save()
                } catch {
                    fatalError("Unable to Save Data")
                }
            }
        }
    }
  
    func loadHiScoreData() {
        //データを取得
        let request = NSFetchRequest<HiScore>(entityName: "HiScore")
        guard let hiScoreData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        //データが存在する場合は取得存在しなければ生成
        ScoreType.allCases.forEach{ score in
            if let hiScoreData = hiScoreData.first(where: { $0.type == String(describing:score)}) {
                hiScores.append(HiScoreModel(type: hiScoreData.type!, value: hiScoreData.value))
            }else{
                hiScores.append(HiScoreModel(type: score))
            }
        }
    }
    
    func loadMoneyData() {
        let request = NSFetchRequest<MoneyModel>(entityName: "MoneyModel")
        guard let moneyModel = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        if moneyModel.isEmpty {
            money = 0
        }else{
            money = Int(moneyModel.first!.value)
        }
    }
}

struct HiScoreModel {
    //初期状態のスコア
    init(type: ScoreType) {
        self.type = type
        if type == .stage {
            self.value = 1
        }
    }
    //データ読み込み時のスコア
    init(type: String, value: Int64) {
        guard let scoreType = ScoreType.allCases.first (where: {String(describing: $0) == type})
        else {
            fatalError("ScoreType指定エラー")
        }
        self.type = scoreType
        self.value = Int(value)
    }
    let type: ScoreType
    var value: Int = 0
    
}
