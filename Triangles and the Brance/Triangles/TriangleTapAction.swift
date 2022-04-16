//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Foundation
import SwiftUI
///ステージ内のTriangleに対するアクションを実行する
///処理を行う場所を特定し、プロパティーの更新を行う
///利用する際にはplansとaddtionalItemを読み取る
class TriangleTapAction {
    private let gameModel = GameModel.shared
    ///アクションの一覧、コストが高い順に格納されている
    private var actionsForGenerateTriangle:[ActionType] = ActionType.allCases.filter{ $0.defaultCost != nil }.sorted{ $0.defaultCost! > $1.defaultCost! }
    
    ///タップしたときのアクションを呼び出す
    func triangleTapAction(index: Int) {
        if gameModel.triangles[index].status == .isOn{
            gameModel.parameter.life -= 1
            trianglesChainAction(index: index)
        }else{
            //アイテムが入っていた場合はtrianglesにセット
            if let selectedItem = gameModel.selectedActionItem{
                switch selectedItem.action {
                case .normal:
                    guard gameModel.parameter.normalActionCount != 0 else{
                        print("カウントゼロの状態にもかかわらず、ノーマルアクションが入っている")
                        return
                    }
                    gameModel.parameter.normalActionCount -= 1
                    gameModel.selectedActionItem = nil
                    gameModel.triangles[index].status = .isOn
                default:
                  
                    let indexOfItem = gameModel.actionItems.firstIndex {
                        $0.id == selectedItem.id
                    }
                    guard let indexOfItem = indexOfItem else {
                        print("アイテムのインデックス取得エラー")
                        return
                    }
                    //removeに戻り値が発生してしまい警告が出るためアンダースコアに代入
                    _ = withAnimation{
                        gameModel.actionItems.remove(at: indexOfItem)
                    }
                    let coordinate = gameModel.triangles[index].coordinate
                    let relativeCoordinate = coordinate.relativeCoordinate(relative: selectedItem.actionCoordinate(reversed: gameModel.triangles[index].reversed))
                    
                    coordinatesInStage(coordinates: relativeCoordinate).forEach {
                        gameModel.triangles[indexOfTrianglesInStage(coordinate: $0)!].status = .isOn
                    }
                    gameModel.selectedActionItem = nil
                }
            }
        }
    }
    
    
    
    ///Triangleのステータスを参照し、アクションを実行するか判断、自身のプロパティを書き換える
    private func trianglesChainAction(index: Int) {
        let coordinate = gameModel.triangles[index].coordinate
        do{
            //
            let plans = try planingDeleteTriangles(coordinate: coordinate)
            let deleteCount = plans.count
            //ディレイをかけながらTriangleのステータスを更新し、完了後にGameModelのプロパティーを更新する
            updateTrianglesStatus(plans: plans){
                self.appendStageItems(count: deleteCount)
                self.gameModel.updateGameParameters(deleteCount: deleteCount)
               
            }
        }catch{
            print("ERROR:\(error)")
        }
    }
    ///一定数以上消していた場合は新しくItemを追加する
    private func appendStageItems(count: Int) {
        for action in actionsForGenerateTriangle{
            if count >= action.defaultCost!{
                withAnimation{
                    gameModel.actionItems.append(ActionItemModel(action: action))
                }
                break
            }
        }
    }
    ///消した数の半分の数を再度Onにする
    private func trianglesDeleteFeedback(plans: [PlanOfChangeStatus]) {
        let numberToAdd = plans.count / 2
        let shuffledIndexIsOff = gameModel.triangles.indices.filter{
            gameModel.triangles[$0].status == .isOff
        }.shuffled()
        shuffledIndexIsOff.prefix(numberToAdd).forEach{
            gameModel.triangles[$0].status = .isOn
        }
    }
    ///順番に描画が更新されるように時間をずらしながらビューを更新する
    private func updateTrianglesStatus(plans: [PlanOfChangeStatus], complesion: @escaping () -> Void) {
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
                            self.gameModel.triangles[plan.index].status = .isOff
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
                complesion()
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
                guard let index = indexOfTrianglesInStage(coordinate: searchingNow)
                else{ throw StageError.triangleIndexError }
                let nextCoordinates = searchingNow.nextCoordinates
                if gameModel.triangles[index].status == .isOn {
                    
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
    private func indexOfTrianglesInStage(coordinate:ModelCoordinate) -> Int?{
        gameModel.triangles.firstIndex{ $0.coordinate == coordinate }
    }
    ///ステージ内にあるかどうかを返す
    private func isInStage(coordinate:ModelCoordinate) -> Bool{
        gameModel.triangles.contains{ $0.coordinate == coordinate }
    }
    ///ステージ内に含まれる座標を返す
    private func coordinatesInStage(coordinates: Set<ModelCoordinate>) -> Set<ModelCoordinate>{
        Set(coordinates.filter{ isInStage(coordinate: $0) })
    }
    ///ステータス変更の予定のセット
    struct PlanOfChangeStatus{
        let index:Int
        let count:Int
    }
}



