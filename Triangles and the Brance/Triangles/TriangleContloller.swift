//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Foundation
import SwiftUI

class TriangleContloller: ObservableObject {
    
    @Published var triangles: [TriangleViewModel] = []
    let triangleIsOnProbability:Double = 40
    var triangleHaveActionProbability:Double = 0
    
    private var triangleArrengement: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    ///ゲーム開始時に呼び出す
    func resetGame() {
        setStageTriangles()
        setTrianglesStatus()
    }
    ///ステージ開始時に呼び出す
    func setParameters() {
        setTrianglesStatus()
    }
    ///三角形のビューのセットアップ
    private func setStageTriangles(){
        triangles = []
        withAnimation{
            for (triangleY, arrangement) in triangleArrengement.enumerated(){
                for triangleX in arrangement{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOff, action: nil )
                    triangles.append(triangleModel)
                }
            }
        }
    }
 
    private func setTrianglesStatus(){
        for index in triangles.indices {
            let random:Double = Double.random(in:1...100)
            if random <= triangleIsOnProbability {
                triangles[index].status = .isOn
                let randomNumber:Double = Double.random(in:1...100)
                if randomNumber <= triangleHaveActionProbability {
                    //MARK: 変更予定
                    triangles[index].actionItem = ActionItem(action: .pyramid)
                }
            }else{
                triangles[index].status = .isOff
            }
        }
    }
    ///タップしたときのアクション
    func triangleTapAction(coordinate: ModelCoordinate) {
        guard GameModel.shared.stageModel.life != 0 else {
            return
        }
        guard let index = indexOfTriangles(coordinate: coordinate) else {
            print("インデックス取得エラー")
            return
        }
        if triangles[index].status == .isOn{
            trianglesChainAction(index: index)
        }else{
            //アイテムが入っていた場合の処理
            if GameModel.shared.itemController.selectedItem != nil {
                //更新する座標を求める
                let itemCoordinate = GameModel.shared.itemController.itemAction(position: .face)
                guard !itemCoordinate.isEmpty else {
                    return
                }
                let coordinate = triangles[index].coordinate
                let coordinates = coordinate.relative(coordinates: itemCoordinate)
                //Trianglesのステータスの更新
                turnOnTriangles(plans: getIndexesOfAction(coordinates: coordinates)) {
                }
            }
        }
    }
    ///Triangleのステータスを参照し、アクションを実行するか判断、自身のプロパティを書き換える
    private func trianglesChainAction(index: Int) {
        let coordinate = triangles[index].coordinate
        do{
            let plans = try planingDeleteTriangles(coordinate: coordinate)
            let deleteCount = plans.count
            //ディレイをかけながらTriangleのステータスを更新し、完了後にGameModelのプロパティーを更新する
            updateTrianglesStatus(plans: plans){
                GameModel.shared.itemController.appendStageItems(count: deleteCount)
                GameModel.shared.updateGameParameters(deleteCount: deleteCount)
            }
        }catch{
            print("ERROR:\(error)")
        }
    }
    ///消した数の半分の数を再度Onにする
    private func trianglesDeleteFeedback(plans: [PlanOfChangeStatus]) {
        let numberToAdd = plans.count / 2
        let shuffledIndexIsOff = triangles.indices.filter {
            triangles[$0].status == .isOff
        }.shuffled()
        shuffledIndexIsOff.prefix(numberToAdd).forEach {
            triangles[$0].status = .isOn
        }
    }
    ///座標のからindexへ変換する
    func getIndexesOfAction(coordinates: [[ModelCoordinate]]) -> [[Int]] {
        coordinates.map { coordinates in
            coordinates.compactMap {
                indexOfTriangles(coordinate: $0)
            }
        }
    }
    ///時間をずらしながらisOnに変更する
    private func turnOnTriangles(plans: [[Int]], completion: @escaping () -> Void) {
        DispatchQueue.global().async { [self] in
            for plan in plans.dropLast(){
                plan.forEach { index in
                    DispatchQueue.main.async {
                        triangles[index].status = .isOn
                    }
                }
                Thread.sleep(forTimeInterval: 0.4)
            }
            plans.last?.forEach { index in
                DispatchQueue.main.async {
                    triangles[index].status = .isOn
                }
            }
            completion()
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
                trianglesDeleteFeedback(plans: plans)
            }
            Thread.sleep(forTimeInterval: 0.6)
            DispatchQueue.main.async{
                completion()
            }
        }
    }
    ///Triangleの消去の順番を求める
    private func planingDeleteTriangles(coordinate:ModelCoordinate) throws ->   [PlanOfChangeStatus]{
        var plan:[PlanOfChangeStatus] = []
        //Offにする予定の座標を設定、一定時間後に消去を行うためにカウンターを用意
        var counter = 0
        var didSearched: Set<ModelCoordinate> = []
        var willSearch: Set<ModelCoordinate> = []
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
                else{ throw StageError.triangleIndexError }
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
    private func indexOfTriangles(coordinate:ModelCoordinate) -> Int?{
        triangles.firstIndex{ $0.coordinate == coordinate }
    }
    ///ステージ内にあるかどうかを返す
    private func isInStage(coordinate:ModelCoordinate) -> Bool{
        triangles.contains{ $0.coordinate == coordinate }
    }
    ///ステージ内に含まれる座標を返す
    private func coordinatesInStage(coordinates: Set<ModelCoordinate>) -> Set<ModelCoordinate>{
        Set(coordinates.filter{ isInStage(coordinate: $0) })
    }
    ///ステータス変更の予定のセット
    private struct PlanOfChangeStatus{
        let index:Int
        let count:Int
    }
}



