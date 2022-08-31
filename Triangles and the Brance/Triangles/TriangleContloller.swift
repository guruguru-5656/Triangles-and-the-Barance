//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Combine
import SwiftUI

final class TriangleContloller: ObservableObject {
    
    private let itemController: ItemController
    @Published var triangles: [TriangleViewModel] = []
    @Published private(set) var fieldOutLine: [TriLine] = []
    @Published private(set) var triangleVertexs: [TriangleVertexCoordinate] = []
    @Published private(set) var fieldLine: [TriLine] = []
    @Published private(set) var numberOfCell: Int = 6
    private let isOnRate: Double = 0.5
    private var recycleRate: Double = 0
    
    init(stageModel: StageModel, itemController: ItemController) {
        self.stageModel = stageModel
        self.itemController = itemController
        loadRecycleRate()
    }
    //イベント通知を受け取る
    private let stageModel: StageModel
    private var subscriber: AnyCancellable?
    func subscribe() {
        subscriber = stageModel.gameEventPublisher
            .sink { [ weak self ] event in
                guard let self = self else {
                    return
                }
                switch event {
                case .stageClear:
                    self.setParameters()
                case .resetGame:
                    self.setParameters()
                default:
                    break
                }
            }
    }
    
    ///ステージ開始時に呼び出す
    func setParameters() {
        loadArrangement(stage: stageModel.stage)
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
        let recycleLevel = SaveData.shared.loadData(name: UpgradeType.recycle)
        recycleRate = Double(UpgradeType.recycle.effect(level: recycleLevel)) / 100
    }
 
    ///タップしたときのアクション
    func triangleTapAction(coordinate: TriangleCenterCoordinate) {
        guard stageModel.life != 0 else {
            return
        }
        guard let index = indexOfTriangles(coordinate: coordinate) else {
            print("インデックス取得エラー")
            return
        }
        //アイテムが入っていた場合の処理を確認、何も行われなかった場合は連鎖して消すアクションを行う
        if itemController.selectedItem != nil {
           itemAction(coordinate: coordinate)
            return
        }
               
        if triangles[index].status == .isOn {
            trianglesChainAction(index: index)
        }
    }
    
    ///itemのアクションを実行する
    func itemAction<T:StageCoordinate>(coordinate: T) {
        //itemが更新する座標を取得
        let itemCoordinates = itemController.itemEffectCoordinates(coordinate: coordinate)
        let actionIndex = getIndexesOfAction(coordinates: itemCoordinates)
        if actionIndex.allSatisfy ({ $0.isEmpty }) {
            itemController.releaseItemSelect()
            return
        }
        itemController.useItem()
        itemController.releaseItemSelect()
        //Trianglesのステータスの更新
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
            itemController.energyChange(plans.count)
            stageModel.updateParameters(deleteCount: deleteCount)
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
    func getIndexesOfAction(coordinates: [[TriangleCenterCoordinate]]) -> [[Int]] {
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
                Thread.sleep(forTimeInterval: 0.4)
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
    private func planingDeleteTriangles(coordinate:TriangleCenterCoordinate) ->  [PlanOfChangeStatus]{
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
    ///ステータス変更の予定のセット
    private struct PlanOfChangeStatus{
        let index:Int
        let count:Int
    }
}
