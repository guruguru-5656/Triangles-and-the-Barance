//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import SwiftUI
import Combine
import AVFoundation

class GameModel: ObservableObject {
    
    @Published var showResultView = false
    @Published var isGameClear = false
    @Published var currentColor: StageColor
    @Published var selectedItem: ActionItemModel?
    @Published var stageStatus: StageStatus
    
    private var maxLife: Int
    private var stage: Int
    let soundPlayer = SEPlayer.shared
    //スコアの生成に利用
    @Published var stageScore: StageScore
    //イベントの発行
    private(set) var gameEventPublisher = PassthroughSubject<GameEvent, Never>()
    let dataStore: DataClass
    
    init(dataStore: DataClass = SaveData.shared) {
        self.dataStore = dataStore
        let stageData = dataStore.loadData(name: StageState.stage)
        //stageDataが0(データが存在しない場合)は1にする
        let formattedStageData = stageData == 0 ? 1 : stageData
        stage = formattedStageData
        maxLife = dataStore.loadData(name: UpgradeType.life) + 5
        
        stageStatus = StageStatus(stage: stage, life: maxLife)
        currentColor = StageColor(stage: formattedStageData)
        stageScore = dataStore.loadData(type: StageScore.self) ?? StageScore()
    }
    
    ///効果を及ぼす座標を返す
    func itemEffectCoordinates<T: StageCoordinate>(coordinate: T) -> [[TriangleCenterCoordinate]]{
        //アイテムが選択されていなければ何もしない
        guard let item = selectedItem else {
            return []
        }
        //入力された座標がitemのpositionと一致するかチェック
        guard T.position == item.type.position else{
            return []
        }
        return coordinate.relative(coordinates: item.type.actionCoordinate)
    }
    
    func useItem() {
        guard let selectedItem = selectedItem else {
            return
        }
        stageStatus.useItem(item: selectedItem)
        self.selectedItem = nil
        gameEventPublisher.send(.itemUsed(selectedItem.cost))
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
    
    func triangleDidDeleted(count: Int) {
        stageScore.triangleDidDeleted(count: count)
        let event = stageStatus.triangleDidDeleted(count: count)
        gameEventPublisher.send(.triangleDeleted(count, stageStatus.clearRate))
        switch event {
        case .stageClear:
            stageClear()
        case .gameOver:
            gameOver()
        case .gameClear:
            gameClear()
        case .none: break
        }
    }
    
    func resetGame() {
        stage = 1
        maxLife = dataStore.loadData(name: UpgradeType.life) + 5
        stageStatus = StageStatus(stage: stage, life: maxLife)
        stageScore = StageScore()
        
        currentColor = StageColor(stage: stage)
        gameEventPublisher.send(.startStage(stage))
        withAnimation {
            showResultView = false
        }
        withAnimation {
            isGameClear = false
        }
        BGMPlayer.shared.play(bgm: .stage)
    }
    
    private func stageClear() {
        gameEventPublisher.send(.clearAnimation)
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            soundPlayer.play(sound: .clearSound)
            try await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                stage += 1
                stageScore.stageUpdate(stage)
                saveStageStatus()
                stageStatus = StageStatus(stage: stage, life: maxLife)
                currentColor.nextColor()
                gameEventPublisher.send(.startStage(stage))
            }
        }
    }
    
    func gameOver() {
        gameEventPublisher.send(.gameOver)
        soundPlayer.play(sound: .gameOverSound)
        BGMPlayer.shared.play(bgm: .gameOver)
        withAnimation {
            showResultView = true
        }
        saveInitialState()
    }
    
    private func gameClear() {
        isGameClear = true
        gameEventPublisher.send(.gameClear)
        BGMPlayer.shared.play(bgm: .ending)
        saveInitialState()
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            soundPlayer.play(sound: .clearSound)
            try await Task.sleep(nanoseconds: 3000_000_000)
            await MainActor.run {
                withAnimation {
                    showResultView = true
                }
                saveStageStatus()
            }
        }
    }
    
    private func saveStageStatus() {
        dataStore.saveData(name: StageState.stage, intValue: stage)
        dataStore.saveData(value: stageScore)
    }
    
    private func saveInitialState() {
        //ステージの進行状況を初期状態で保存
        dataStore.saveData(name: StageState.stage, intValue: 1)
        dataStore.saveData(value: StageScore())
    }
}

enum GameEvent {
    case triangleDeleted (Int , Double)
    case itemUsed (Int)
    case clearAnimation
    case startStage(Int)
    case gameOver
    case gameClear
}

//データ保存用の名前
enum StageState: SaveDataName {
    case stage
}
