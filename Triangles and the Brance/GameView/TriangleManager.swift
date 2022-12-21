//
//  File.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/14.
//

import Foundation
import Combine

class TriangleManager {
    var triangles: [TriangleModel] = []
    private var animationStatus: AnimationStatus = .noAnimation
    private weak var delegate: TriangleManagerDelegate?
    private var recycleRate: Double = 0
    private let dataStore: DataClass
    typealias Plan = [[TriangleModel]]
    let publisher = PassthroughSubject<Action, Never>()
    
    init(stage: Int, dataStore: DataClass) {
        self.dataStore = dataStore
        loadRecycleRate()
        var field = TriangleField.loadField(stage)
        if let triangles = dataStore.loadData(type: [TriangleModel].self) {
            if field.triangles.count == triangles.count {
                self.triangles = triangles
                return
            }
        }
        field.setTriangleStatus()
        triangles = field.triangles
    }
    
    func setDelegate(_ delegate: TriangleManagerDelegate) {
        self.delegate = delegate
    }
    
    func triangleChainAction(model: TriangleModel) async throws -> Int {
        guard animationStatus == .noAnimation else {
            throw ActionError.animationIsRunning
        }
        let plan = planingDeleteTriangles(coordinate: model.coordinate)
        guard !plan.isEmpty else {
            throw ActionError.couldNotDoAction
        }
        let deleteCount = plan.reduce(0) { $0 + $1.count }
        let recycleTriangles = recycleTriangles(deleteCount: deleteCount)
        let statusChanger = StatusChanger(plan: plan)
        let stream = statusChanger.makeStream(duration: 0.4)
        recycleTriangles.forEach { updateStatus(model: $0) }
        animationStatus = .triangleDeleting
        var counter = 0
        for await models in stream {
            publisher.send(.triangleStatusChange(models))
            publisher.send(.playSound(counter))
            counter += 1
        }
        publisher.send(.triangleStatusChange(recycleTriangles))
        animationStatus = .noAnimation
        return deleteCount
    }
    
    ///一定割合復活させる
    private func recycleTriangles(deleteCount: Int) -> [TriangleModel] {
        let numberToRecycle = Int(ceil(Double(deleteCount) * recycleRate))
        let shuffledIndex = triangles.indices.filter {
            triangles[$0].status == .isOff
        }.shuffled()
        return shuffledIndex.prefix(numberToRecycle).map {
            TriangleModel(coordinate: triangles[$0].coordinate, status: .isOn)
        }
    }
    
    ///Triangleの消去の順番を求める
    private func planingDeleteTriangles(coordinate:TriangleCenterCoordinate) ->  Plan {
        var plans: Plan = []
        var searched: Set<TriangleCenterCoordinate> = []
        var willSearch: Set<TriangleCenterCoordinate> = []
        willSearch.insert(coordinate)
        while !willSearch.isEmpty {
            var plan: [TriangleModel] = []
            for searchingNow in willSearch {
                searched.insert(searchingNow)
                guard let status = checkStatus(at: searchingNow) else {
                    continue
                }
                if status == .isOn {
                    let model = TriangleModel(coordinate: searchingNow, status: .isOff)
                    plan.append(model)
                    updateStatus(model: model)
                    willSearch.formUnion(searchingNow.nextCoordinates)
                }
            }
            willSearch.subtract(searched)
            if !plan.isEmpty {
                plans.append(plan)
            }
        }
        return plans
    }
    
    private func checkStatus(at coordinate: TriangleCenterCoordinate) -> ViewStatus? {
        triangles.first {
            $0.coordinate == coordinate
        }?.status
    }
    
    private func updateStatus(model: TriangleModel) {
        let index = triangles.firstIndex { $0.coordinate == model.coordinate }
        guard let index = index else { return }
        triangles[index].status = model.status
    }

    ///itemのアクションを実行する
    func itemAction<T:StageCoordinate>(coordinate: T, item: ActionItemModel) throws {
        //itemが更新する座標を取得
        let itemCoordinates = item.type.itemEffectCoordinates(coordinate: coordinate)
        let plan = planningItemAction(coordinate: itemCoordinates)
        //アイテムの効果がない場合は使わずに処理を終了する
        let flatMappedPlan = plan.flatMap({ $0 })
        guard !flatMappedPlan.isEmpty else {
            throw ActionError.couldNotDoAction
        }
        flatMappedPlan.forEach { updateStatus(model: $0) }
        let statusChanger = StatusChanger(plan: plan)
        let stream = statusChanger.makeStream(duration: 0.2)
        Task {
            animationStatus = .itemUsing
            for await models in stream {
                publisher.send(.triangleStatusChange(models))
            }
            animationStatus = .noAnimation
        }
    }
    
    func planningItemAction(coordinate: [[TriangleCenterCoordinate]]) -> Plan {
        var plans = Plan()
        for coordinat in coordinate {
            var plan = [TriangleModel]()
            coordinat.forEach { coor in
                if checkStatus(at: coor) == .isOff {
                    plan.append(TriangleModel(coordinate: coor, status: .isOn))
                }
            }
            plans.append(plan)
        }
        return plans
    }
    
    private class StatusChanger {
        init(plan: Plan) {
            unprocessed = plan.flatMap { $0 }
            self.plan = plan
        }
        private let plan: Plan
        private var unprocessed: [TriangleModel]
        
        func makeStream(duration: Double) -> AsyncStream<[TriangleModel]> {
            AsyncStream<[TriangleModel]> { continuation in
                let task = Task {
                    for stream in plan {
                        stream.forEach { remove(model: $0) }
                        continuation.yield(stream)
                        //durationの指定は秒単位で小数点第三位まで指定可能
                        try await Task.sleep(nanoseconds: UInt64(duration * 1000) * 1000_000)
                    }
                    continuation.finish()
                }
                continuation.onTermination = { @Sendable [unowned self]  termination in
                    switch termination {
                    case .cancelled:
                        task.cancel()
                        //キャンセルした場合は残った処理をまとめて実行
                        continuation.yield(self.unprocessed)
                    case .finished: break
                    @unknown default:
                        print("Undefined termination is called.")
                    }
                }
            }
        }
        
        func remove(model: TriangleModel) {
            guard let index = unprocessed.firstIndex(where: { $0 == model }) else { return }
            unprocessed.remove(at: index)
        }
    }
    
    func start(stage: Int) {
        var field = TriangleField.loadField(stage)
        field.setTriangleStatus()
        triangles = field.triangles
        publisher.send(.setTriangleField(field))
        loadRecycleRate()
    }
    
    func setTriangleStatus(isOnCount: Int) {
        let randomIndex = triangles.indices.shuffled()
        for index in randomIndex.prefix(isOnCount) {
            triangles[index].status = .isOn
        }
        for index in randomIndex.suffix(triangles.count - isOnCount) {
            triangles[index].status = .isOff
        }
    }
  
    func initializeTriangleViewModel() {
        guard let stage = delegate?.getStageNumber() else {
            print("delegateが設定されていない")
            return
        }
        var field = TriangleField.loadField(stage)
        field.triangles = self.triangles
        publisher.send(.setTriangleField(field))
    }
    
    private func loadRecycleRate() {
        let recycleLevel = dataStore.loadData(name: UpgradeType.recycle)
        recycleRate = Double(UpgradeType.recycle.effect(level: recycleLevel)) / 100
    }
    
    enum Action {
        case triangleStatusChange([TriangleModel])
        case playSound(Int)
        case setTriangleField(TriangleField)
    }
    
    enum ActionError: Error {
        case couldNotDoAction
        case animationIsRunning
    }
    
    enum AnimationStatus {
        case itemUsing
        case triangleDeleting
        case noAnimation
    }
}

protocol TriangleManagerDelegate: AnyObject {
    func triangleDidDeleted(count: Int)
    func getStageNumber() -> Int
}
