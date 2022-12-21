//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import SwiftUI
import Combine
import AVFoundation

class GameModel: ObservableObject, TriangleManagerDelegate {
    
    @Published var showResultView = false
    @Published var isGameClear = false
    @Published var currentColor: StageColor
    @Published var selectedItem: ActionItemModel?
    @Published var stageStatus: StageStatus
    @Published var stageScore: StageScore
    @Published var actionItems: [ActionItemModel] = []
    
    private var maxLife: Int {
        dataStore.loadData(name: UpgradeType.life) + 5
    }
    let dataStore: DataClass
    let soundPlayer = SEPlayer.shared
    private var onStageClear = false
    //viewModelへの通知
    let triangleDeletedPublisher = PassthroughSubject<(count: Int, clearRate: Double), Never>()
    let clearAnimationPublisher = PassthroughSubject<Void, Never>()
    let startStagePublisher = PassthroughSubject<Int, Never>()
    let gameOverPublisher = PassthroughSubject<Void, Never>()
    let gameClearPublisher = PassthroughSubject<Void, Never>()
    private (set) var triangleManager: TriangleManager
  
    init(dataStore: DataClass = SaveData.shared) {
        self.dataStore = dataStore
        let stageStatusData = dataStore.loadData(type: StageStatus.self)
        let stage: Int
        if let stageStatusData = stageStatusData {
            stageStatus = stageStatusData
            stage = stageStatusData.stage
        } else {
            stage = 1
            let maxLife = dataStore.loadData(name: UpgradeType.life) + 5
            stageStatus = StageStatus(stage: stage, life: maxLife)
        }
        currentColor = StageColor(stage: stage)
        stageScore = dataStore.loadData(type: StageScore.self) ?? StageScore()
        triangleManager = TriangleManager(stage: stage, dataStore: dataStore)
        triangleManager.setDelegate(self)
        loadItemTable()
    }
  
    ///タップしたときのアクション
    func triangleTapAction(model: TriangleModel) {
        guard !onStageClear else { return }
        guard stageStatus.life != 0 else {
            soundPlayer.play(sound: .cancelSound)
            return
        }
        //アイテムが入っていた場合の処理を確認、何も行われなかった場合は連鎖して消すアクションを行う
        if let item = selectedItem {
            do {
                try triangleManager.itemAction(coordinate: model.coordinate, item: item)
                itemUsed()
            } catch {
                soundPlayer.play(sound: .cancelSound)
            }
            return
        }
        Task {
            do {
                let count = try await triangleManager.triangleChainAction(model: model)
                await triangleDidDeleted(count: count)
            } catch {
                soundPlayer.play(sound: .cancelSound)
            }
        }
    }

    func itemAction(coordinate: StageCoordinate) {
        guard !onStageClear else { return }
        guard let item = selectedItem else { return }
        do {
            try triangleManager.itemAction(coordinate: coordinate, item: item)
            itemUsed()
        } catch {
            soundPlayer.play(sound: .cancelSound)
        }
    }
    
    func itemUsed() {
        guard let selectedItem = selectedItem else {
            return
        }
        stageStatus.useItem(item: selectedItem)
        self.selectedItem = nil
        soundPlayer.play(sound: .itemUsed)
    }
    
    func itemSelect(model: ActionItemModel) {
        //現在選択しているItemと同じものを選択した場合、選択を解除する
        if model.id == selectedItem?.id {
            selectedItem = nil
            return
        }
        if stageStatus.canUseItem(cost: model.cost) {
            selectedItem = model
            soundPlayer.play(sound: .selectSound)
        } else {
            soundPlayer.play(sound: .cancelSound)
        }
        return
    }
    
    func resetGame() {
        let stage = 1
        stageStatus = StageStatus(stage: stage, life: maxLife)
        stageScore = StageScore()
        currentColor = StageColor(stage: stage)
        loadItemTable()
        triangleManager.start(stage: stage)
        withAnimation {
            showResultView = false
        }
        withAnimation {
            isGameClear = false
        }
        BGMPlayer.shared.play(bgm: .stage)
    }
    
    private func stageClear() {
        clearAnimationPublisher.send()
        Task {
            onStageClear = true
            soundPlayer.play(sound: .clearSound, delay: 0.5)
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                let nextStage = stageStatus.stage + 1
                stageScore.stageUpdate(nextStage)
                stageStatus = StageStatus(stage: nextStage, life: maxLife)
                currentColor.next()
                startStagePublisher.send(nextStage)
                triangleManager.start(stage: nextStage)
                saveStageStatus()
            }
            onStageClear = false
        }
    }
    
    func gameOver() {
        gameOverPublisher.send()
        soundPlayer.play(sound: .gameOverSound)
        BGMPlayer.shared.play(bgm: .gameOver)
        withAnimation {
            showResultView = true
        }
        saveInitialState()
    }
    
    private func gameClear() {
        isGameClear = true
        gameClearPublisher.send()
        soundPlayer.play(sound: .clearSound, delay: 0.5)
        BGMPlayer.shared.play(bgm: .ending, delay: 3)
        Task {
            try await Task.sleep(nanoseconds: 3000_000_000)
            await MainActor.run {
                withAnimation {
                    showResultView = true
                }
            }
        }
        saveInitialState()
    }
    
    private func saveStageStatus() {
        dataStore.saveData(value: stageStatus)
        dataStore.saveData(value: stageScore)
        dataStore.saveData(value: triangleManager.triangles)
    }
    
    private func saveInitialState() {
        //ステージの進行状況を初期状態で保存
        dataStore.removeData(value: StageStatus.self)
        dataStore.removeData(value: StageScore.self)
        dataStore.removeData(value: [TriangleModel].self)
    }
    
    private func loadItemTable() {
        actionItems = ActionType.allCases.map { actionType -> ActionItemModel in
            if let upgradeType = UpgradeType(actionType: actionType) {
                let saveData = dataStore.loadData(name: upgradeType)
                return ActionItemModel(type: actionType, level: saveData)
            }
            return ActionItemModel(type: actionType, level: 1)
        }
    }
    
    //TriangleManagerDelegate
    @MainActor
    func triangleDidDeleted(count: Int) {
        stageScore.triangleDidDeleted(count: count)
        let event = stageStatus.triangleDidDeleted(count: count)
        switch event {
        case .stageClear:
            stageClear()
        case .gameOver:
            gameOver()
        case .gameClear:
            gameClear()
        case .none:
            triangleDeletedPublisher.send((count, stageStatus.clearRate))
        }
    }
    
    func getStageNumber() -> Int {
        return stageStatus.stage
    }
}
