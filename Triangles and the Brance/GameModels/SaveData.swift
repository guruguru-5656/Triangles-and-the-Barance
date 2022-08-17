//
//  SaveData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import Foundation
import CoreData


final class SaveData {
    
    private lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    private lazy var context: NSManagedObjectContext = {
        return container.viewContext
    }()
 
    static let shareData = SaveData()
    private init() {

    }
  
    func saveHiScoreData(){
        do {
            try context.save()
        } catch {
            fatalError("Unable to Save Data")
        }
    }
    
    func savePointData(point: Int) {
        let request = NSFetchRequest<PointsModel>(entityName: "PointsModel")
        guard let pointData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        if pointData.isEmpty  {
            let model = PointsModel(context: context)
            model.value = Int64(point)
        } else {
            pointData.first!.value = Int64(point)
        }
        do {
            try context.save()
        } catch {
            fatalError("Unable to Save Data")
        }
    }

    func saveUpgradeData(model: [UpgradeItemViewModel]) {
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
    
    func loadUpgradeData() -> [UpgradeItemViewModel] {
        let request = NSFetchRequest<UpGrade>(entityName: "UpGrade")
        guard let loadData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        var itemModels:[UpgradeItemViewModel] = []
        //データが存在する場合は取得存在しなければ生成
        UpgradeType.allCases.forEach{ type in
            if let loadData = loadData.first(where: {$0.type == String(describing: type)}) {
                itemModels.append(UpgradeItemViewModel(type: loadData.type!, level: loadData.level))
            }else{
                itemModels.append(UpgradeItemViewModel(type: type))
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
        return itemModels
    }
  
    func loadHiScoreData() -> [HiScore] {
        let request = NSFetchRequest<HiScore>(entityName: "HiScore")
        guard let hiScoreData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        var hiScoreModel:[HiScore] = []
        //データが存在する場合は取得存在しなければ生成
        ScoreType.allCases.forEach{ score in
            if let hiScoreData = hiScoreData.first(where: { $0.type == String(describing:score)}) {
                hiScoreModel.append(hiScoreData)
            }else{
                let dataModel = HiScore(context: context)
                dataModel.type = String(describing: score)
                dataModel.value = 0
                try! context.save()
                hiScoreModel.append(dataModel)
            }
        }
        return hiScoreModel
    }
    
    func loadPointData() -> Int {
        let request = NSFetchRequest<PointsModel>(entityName: "PointsModel")
        guard let pointsData = try? context.fetch(request) else {
            fatalError("Unable to load Data")
        }
        if pointsData.isEmpty {
            let firstModel = PointsModel(context: context)
            firstModel.value = 0
            try! context.save()
            return 0
        }else{
            return Int(pointsData.first!.value)
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

