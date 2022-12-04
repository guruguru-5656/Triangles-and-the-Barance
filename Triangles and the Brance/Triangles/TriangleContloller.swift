//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Combine
import SwiftUI

final class TriangleContloller: ObservableObject {
      
    @Published var triangles: [TriangleViewModel] = []
    @Published private(set) var fieldOutLine: [TriLine] = []
    @Published private(set) var triangleVertexs: [TriangleVertexCoordinate] = []
    @Published private(set) var fieldLine: [TriLine] = []
    @Published private(set) var numberOfCell: Int = 6
    private let isOnRate: Double = 0.5
    private var recycleRate: Double = 0
    private let soundPlayer = SEPlayer.shared
    
    func setUp(gameModel: GameModel) {
        self.gameModel = gameModel
        subscribe(gameModel: gameModel)
        loadArrangement(stage: gameModel.stageStatus.stage)
        setTrianleVertexs()
        let triangles = gameModel.dataStore.loadData(type: [TriangleViewModel].self) ?? []
        if triangles.isEmpty {
            setTrianglesStatus()
        } else {
            self.triangles = triangles
        }
        loadRecycleRate()
    }
    
    //イベント通知を受け取る
    private var gameModel: GameModel?
    private var subscriber: AnyCancellable?
    private func subscribe(gameModel: GameModel) {
        subscriber = gameModel.gameEventPublisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                if case .startStage(let stage) = event {
                    self.startStage(at : stage)
                    gameModel.dataStore.saveData(value: self.triangles)
                }
            }
    }
    private func startStage(at stage: Int) {
        loadArrangement(stage: stage)
        setTrianleVertexs()
        setTrianglesStatus()
        loadRecycleRate()
    }
    ///ステージ配置をセットする
    private func loadArrangement(stage: Int) {
        let field = TriangleField.loadField(stage)
        numberOfCell = field.numberOfCell
        triangles = field.triangles
        fieldLine = field.fieldLines
        fieldOutLine = field.fieldOutLines
    }
    ///triangle配列をランダムにOnにする
    private func setTrianglesStatus() {
        let randomIndex = triangles.indices.shuffled()
        let isOnCount = Int(Double(triangles.count) * isOnRate)
        for index in randomIndex.prefix(isOnCount) {
            triangles[index].status = .isOn
        }
        for index in randomIndex.suffix(triangles.count - isOnCount) {
            triangles[index].status = .isOff
        }
    }
    ///頂点の配列の生成
    private func setTrianleVertexs() {
        let vertexs = triangles.flatMap {
            $0.vertexCoordinate
        }
        triangleVertexs = Array(Set(vertexs))
    }
    ///アップグレードのデータからrecycleのlevelを読み込み
    private func loadRecycleRate() {
        let recycleLevel = gameModel!.dataStore.loadData(name: UpgradeType.recycle)
        recycleRate = Double(UpgradeType.recycle.effect(level: recycleLevel)) / 100
    }
 
    ///タップしたときのアクション
    func triangleTapAction(coordinate: TriangleCenterCoordinate) {
        guard let gameModel = gameModel else {
            return
        }

        guard gameModel.stageStatus.life != 0 else {
            return
        }
        guard let index = indexOfTriangles(coordinate: coordinate) else {
            print("インデックス取得エラー")
            return
        }
        //アイテムが入っていた場合の処理を確認、何も行われなかった場合は連鎖して消すアクションを行う
        if gameModel.selectedItem != nil {
           itemAction(coordinate: coordinate)
            return
        }
               
        if triangles[index].status == .isOn {
            trianglesChainAction(index: index)
        }
    }
    
    ///itemのアクションを実行する
    func itemAction<T:StageCoordinate>(coordinate: T) {
        guard let selectedItem = gameModel?.selectedItem else {
            return
        }
        //itemが更新する座標を取得
        let itemCoordinates = selectedItem.type.itemEffectCoordinates(coordinate: coordinate)
        let actionIndex = getIndexesOfAction(coordinates: itemCoordinates)
        if actionIndex.allSatisfy ({ $0.isEmpty }) {
            return
        }
        gameModel?.useItem()
        turnOnTriangles(plans: actionIndex)
        return
    }
    
    ///Triangleのステータスを参照し、アクションを実行するか判断、自身のプロパティを書き換える
    private func trianglesChainAction(index: Int) {
        let coordinate = triangles[index].coordinate
        let plans = planingDeleteTriangles(coordinate: coordinate)
        let deleteCount = plans.count
        //ディレイをかけながらTriangleのステータスを更新、その後のイベント処理を行う
        updateTrianglesStatus(plans: plans){ [self] in
            gameModel?.triangleDidDeleted(count: deleteCount)
        }
    }
    ///一定割合復活させる
    private func trianglesDeleteFeedback(plans: [PlanOfChangeStatus]) {
        let numberToAdd = Int(ceil(Double(plans.count) * recycleRate))
        let shuffledIndexIsOff = triangles.indices.filter {
            triangles[$0].status == .isOff
        }.shuffled()
        shuffledIndexIsOff.prefix(numberToAdd).forEach {
            triangles[$0].status = .isOn
        }
    }
    ///座標からindexへ変換、更新がない座標を取り除く
    private func getIndexesOfAction(coordinates: [[TriangleCenterCoordinate]]) -> [[Int]] {
        coordinates.map { coordinates in
            coordinates.compactMap {
                indexOfTriangles(coordinate: $0)
            }.filter {
                triangles[$0].status == .isOff
            }
        }
    }
    ///時間をずらしながらisOnに変更する
    private func turnOnTriangles(plans: [[Int]]) {
        DispatchQueue.global().async { [self] in
            for plan in plans.dropLast(){
                plan.forEach { index in
                    DispatchQueue.main.async {
                        self.triangles[index].status = .isOn
                    }
                }
                Thread.sleep(forTimeInterval: 0.2)
            }
            plans.last?.forEach { index in
                DispatchQueue.main.async {
                    self.triangles[index].status = .isOn
                }
            }
        }
    }
    ///順番に描画が更新されるように時間をずらしながらビューを更新する
    private func updateTrianglesStatus(plans: [PlanOfChangeStatus], completion: @escaping () -> Void) {
        var counter = 0
        //カウントごとに処理を分けて、ディレイをかけながら順番に実行する
        DispatchQueue.global().async{ [self] in
            while !plans.filter({ $0.count == counter }).isEmpty {
                let separatedPlan = plans.filter {
                    $0.count == counter
                }
                if counter != 0{
                    Thread.sleep(forTimeInterval: 0.4)
                }
                //効果音を再生する
                playChainActionSound(index: counter)
                //ステータスの更新を行う
                for plan in separatedPlan {
                    DispatchQueue.main.async{
                            self.triangles[plan.index].status = .isOff
                    }
                }
                counter += 1
            }
            Thread.sleep(forTimeInterval: 0.4)
            DispatchQueue.main.async {
                self.trianglesDeleteFeedback(plans: plans)
            }
            DispatchQueue.main.async{
                completion()
            }
        }
    }
    ///Triangleの消去の順番を求める
    private func planingDeleteTriangles(coordinate:TriangleCenterCoordinate) ->  [PlanOfChangeStatus] {
        var plan:[PlanOfChangeStatus] = []
        //Offにする予定の座標を設定、一定時間後に消去を行うためにカウンターを用意
        var counter = 0
        var didSearched: Set<TriangleCenterCoordinate> = []
        var willSearch: Set<TriangleCenterCoordinate> = []
        willSearch.insert(coordinate)
        while !willSearch.isEmpty {
            let searching = willSearch
            for searchingNow in searching {
                //先にdidsearchedに入れる理由はステージの範囲外だった場合に処理が完了しなくなるため
                didSearched.insert(searchingNow)
                //ステージの範囲外かチェック、範囲外だった場合は次のループへ
                if !isInStage(coordinate: searchingNow) {
                    continue
                }
                //インデックスの取得チェック
                guard let index = indexOfTriangles(coordinate: searchingNow)
                else{ fatalError("インデックス取得エラー") }
                let nextCoordinates = searchingNow.nextCoordinates
                if triangles[index].status == .isOn {
                        plan.append(PlanOfChangeStatus(index: index, count: counter))
                        willSearch.formUnion(nextCoordinates)
                }
            }
            //処理が一巡終わった際に次の探索予定とカウンターを更新
            willSearch.subtract(didSearched)
            counter += 1
        }
        return plan
    }
    ///Triangleの座標で検索を行い、ステージ配列のインデックスを取得する
    private func indexOfTriangles(coordinate:TriangleCenterCoordinate) -> Int?{
        triangles.firstIndex{ $0.coordinate == coordinate }
    }
    ///ステージ内にあるかどうかを返す
    private func isInStage(coordinate:TriangleCenterCoordinate) -> Bool{
        triangles.contains{ $0.coordinate == coordinate }
    }
    ///ステージ内に含まれる座標を返す
    private func coordinatesInStage(coordinates: Set<TriangleCenterCoordinate>) -> Set<TriangleCenterCoordinate>{
        Set(coordinates.filter{ isInStage(coordinate: $0) })
    }
    ///ステータス変更の予定
    private struct PlanOfChangeStatus{
        let index:Int
        let count:Int
    }
    ///indexで指定して音声を再生する
    ///用意している音声より後のindexを渡した場合は最後の部分を再生する
    private func playChainActionSound(index: Int) {
        let limitedIndex = index < 8 ? index + 1 : 8
        let sound = SEPlayer.Sound(rawValue: "marimba_" + String(limitedIndex))!
        soundPlayer.play(sound: sound)
    }
}
