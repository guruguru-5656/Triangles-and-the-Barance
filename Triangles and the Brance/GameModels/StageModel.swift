//
//  GameParameters.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/08.
//

import SwiftUI
import Combine
import AVFoundation

class StageModel: ObservableObject {
    
    @Published var isPresented = true
    @Published var showResultView = false
    @Published var isGameClear = false
    @Published var stage: Int
    @Published var currentColor: StageColor
    @Published var deleteCount: Int = 0
    @Published var life: Int
    @Published var selectedItem: ActionItemModel?
    @Published var energy: Int = 0
    private var maxLife = 3
    var maxCombo: Int = 0
    //目標値
    var targetDeleteCount: Int {
        targetList[stage - 1]
    }
    
    private let targetList = [10, 15, 20, 25, 30, 36, 43, 50, 57, 63, 70, 80]
    //スコアの生成に利用
    private (set) var stageLogs: [StageLog] = []
    //イベントの発行
    private(set) var gameEventPublisher = PassthroughSubject<GameEventObject, Never>()
    let dataStore: DataClass
    
    init(dataStore: DataClass = SaveData.shared) {
        self.dataStore = dataStore
        let stageData = dataStore.loadData(name: StageState.stage)
        //stageDataが0(データが存在しない場合)は1にする
        let formattedStageData = stageData == 0 ? 1 : stageData
        stage = formattedStageData
        currentColor = StageColor(stage: formattedStageData)
        maxLife = dataStore.loadData(name: UpgradeType.life) + 5
        stageLogs = dataStore.loadData(name: StageLogs.log, valueType: Array<StageLog>.self) ?? []
        life = maxLife
    }
    
    ///効果を及ぼす座標を返す
    func itemEffectCoordinates<T: StageCoordinate>(coordinate: T) -> [[TriangleCenterCoordinate]]{
        //アイテムが選択されていなければ何もしない
        guard let item = selectedItem else {
            return []
        }
        //入力された座標がitemのpositionと一致するかチェック
        guard coordinate.position == item.type.position else{
            return []
        }
        return coordinate.relative(coordinates: item.type.actionCoordinate)
    }
    
    func useItem() {
        guard let selectedItem = selectedItem else {
            return
        }
        life -= 1
        energy -= selectedItem.cost!
        self.selectedItem = nil
        gameEventPublisher.send(.init(.itemUsed, value: selectedItem.cost!))
        if life == 0 {
            gameOver()
        }
    }
    
    func itemSelect(model: ActionItemModel) {
        guard life > 0 else {
            return
        }
        //現在選択しているItemと同じものを選択した場合、選択を解除する
        if model.id == selectedItem?.id {
            selectedItem = nil
            return
        }
        //コストが現在のエネルギーより小さい場合は選択する
        if model.cost ?? .max <= energy {
            selectedItem = model
            itemSelectSound?.play()
        }
        return
    }
    
    func triangleDidDeleted(count: Int) {
        self.deleteCount += count
        energy += count
        life -= 1
        if maxCombo < count {
            maxCombo = count
        }
        gameEventPublisher.send(.init(.triangleDeleted, value: count))
        //イベントの判定
        if self.deleteCount >= targetDeleteCount {
            if stage == 12 {
                gameClear()
                return
            } else {
                stageClear()
                return
            }
        }
        if life == 0 {
            gameOver()
        }
    }
    
    func giveUp() {
        gameOver()
    }
    
    func resetGame() {
        stage = 1
        currentColor = StageColor(stage: 1)
        maxLife = dataStore.loadData(name: UpgradeType.life) + 5
        resetStageParameter()
        gameEventPublisher.send(.init(.resetGame))
        withAnimation {
            showResultView = false
        }
        withAnimation {
            isGameClear = false
        }
        changeBgm(to: .stage)
    }
    
    private func stageClear() {
        gameEventPublisher.send(.init(.clearAnimation))
        Task {
            try await Task.sleep(nanoseconds: 1000_000_000)
            await MainActor.run {
                createLog()
                stage += 1
                currentColor.nextColor()
                deleteCount = 0
                maxCombo = 0
                energy = 0
                life = maxLife
                saveStageStatus()
                gameEventPublisher.send(.init(.stageClear))
            }
        }
    }
    
    private func gameOver() {
        createLog()
        gameEventPublisher.send(.init(.gameOver))
        gameOverSound?.play()
        changeBgm(to: .gameOver)
        withAnimation {
            showResultView = true
        }
        //データを初期状態でセーブ
        dataStore.saveData(name: StageState.stage, intValue: 1)
        let initialLog: [StageLog] = []
        dataStore.saveData(name: StageLogs.log, value: initialLog)
    }
    
    private func gameClear() {
        isGameClear = true
        gameEventPublisher.send(.init(.gameClear))
        
        changeBgm(to: .ending)
        //データを初期状態でセーブ
        dataStore.saveData(name: StageState.stage, intValue: 1)
        let initialLog: [StageLog] = []
        dataStore.saveData(name: StageLogs.log, value: initialLog)
        Task {
            try await Task.sleep(nanoseconds: 3000_000_000)
            await MainActor.run {
                withAnimation {
                    showResultView = true
                }
                createLog()
                saveStageStatus()
            }
        }
    }
    
    private func resetStageParameter() {
        deleteCount = 0
        maxCombo = 0
        energy = 0
        life = maxLife
        stageLogs = []
    }
    
    private func createLog() {
        let log = StageLog(stage: stage, deleteCount: deleteCount, maxCombo: maxCombo)
        stageLogs.append(log)
    }
    
    private func saveStageStatus() {
        dataStore.saveData(name: StageState.stage, intValue: stage)
        dataStore.saveData(name: StageLogs.log, value: stageLogs)
    }
    //SE再生
    private var gameOverSound = EffectSoundPlayer(name: "gameOverSound")
    var itemSelectSound = EffectSoundPlayer(name: "selectSound")
    
    //BGM再生
    private var stageBgm: AVAudioPlayer?
    
    func startBgm(){
        if stageBgm?.isPlaying ?? false {
            return
        }
        play(bgm: .stage)
    }
    
    private func changeBgm(to bgm: Bgm) {
        stageBgm?.setVolume(0, fadeDuration: 1)
        Task {
            let waitTime: UInt64 = bgm == .ending ? 3000_000_000 : 1000_000_000
            try await Task.sleep(nanoseconds: waitTime)
            await MainActor.run {
                stageBgm?.stop()
                play(bgm: bgm)
            }
        }
    }
    
    private func play(bgm: Bgm) {
        guard let url = Bundle.main.url(forResource: bgm.faileName, withExtension: "mp3") else {
            return
        }
        self.stageBgm = try? AVAudioPlayer.init(contentsOf: url)
        
        stageBgm?.numberOfLoops = -1
        stageBgm?.play()
    }
    
    private enum Bgm {
        case stage
        case gameOver
        case ending
        var faileName: String {
            switch self {
            case .stage:
                return "stageBGM"
            case .gameOver:
                return "gameOverBGM"
            case .ending:
                return  "endingBGM"
            }
        }
    }
}

enum GameEvent {
    case triangleDeleted
    case itemUsed
    case clearAnimation
    case stageClear
    case gameOver
    case gameClear
    case resetGame
}

struct GameEventObject {
    let event: GameEvent
    let value: Int?
    init(_ event: GameEvent) {
        self.event = event
        self.value = nil
    }
    init(_ event: GameEvent, value: Int) {
        self.event = event
        self.value = value
    }
}


struct StageLog:Codable, Hashable {
    let stage: Int
    let deleteCount: Int
    let maxCombo: Int
}

//データ保存用の名前
enum StageState: SaveDataName {
    case stage
}

enum StageLogs: SaveDataName {
    case log
}
