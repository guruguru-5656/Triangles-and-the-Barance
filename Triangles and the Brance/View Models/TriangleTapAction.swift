//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Foundation
///ステージ内のTriangleに対するアクションを実行する
///処理を行う場所を特定し、プロパティーの更新を行う
///利用する際にはplansとaddtionalItemを読み取る
class TriangleTapAction {
    init(stage:GameModel) {
        self.stage = stage
    }
    private let stage: GameModel
    ///アクションの一覧、コストが高い順に格納されている
    private var actionsForGenerateTriangle:[ActionType] = ActionType.allCases.filter{ $0.cost != nil }.sorted{ $0.cost! > $1.cost! }
    ///Triangleのステータスを参照し、アクションを実行するか判断、自身のプロパティを書き換える
    func trianglesTapAction(index:Int) {
        let coordinate = stage.triangles[index].coordinate
        do{
            //
            let plans = try planingDeleteTriangles(coordinate: coordinate)
            let deleteCount = plans.filter{
                $0.changeStatus == .toTurnOff || $0.changeStatus == .toTurnOffWithAction
            }.count
            updateTrianglesStatus(plans: plans){
                self.appendStageItems(count: deleteCount)
                self.stage.deleteCount += deleteCount
            }
        }catch{
            print("ERROR:\(error)")
        }
    }
    ///一定数以上消していた場合は新しくItemを追加する
    private func appendStageItems(count: Int) {
        for action in actionsForGenerateTriangle{
            if count >= action.cost!{
                stage.actionItems.append(ActionItemModel(action: action))
                break
            }
        }
    }
    ///消した数の半分の数を再度Onにする
    private func trianglesDeleteFeedback(plans: [PlanOfChangeStatus]){
        let numberToAdd = plans.filter{
            $0.changeStatus == .toTurnOffWithAction || $0.changeStatus == .toTurnOff
        }.count / 2
        let shuffledIndexIsOff = stage.triangles.indices.filter{
            stage.triangles[$0].status == .isOff
        }.shuffled()
        shuffledIndexIsOff.prefix(numberToAdd).forEach{
            stage.triangles[$0].status = .isOn
        }
    }
    ///順番に描画が更新されるように時間をずらしながらビューを更新する
    private func updateTrianglesStatus(plans: [PlanOfChangeStatus], complesion: @escaping () -> Void) {
        var counter = 0
        //カウントごとに処理を分けて、ディレイをかけながら順番に実行する
        DispatchQueue.global().async{ [self] in
            while !plans.filter({ $0.count == counter }).isEmpty {
                let filterdPlan = plans.filter {
                    $0.count == counter
                }
                if counter != 0{
                    Thread.sleep(forTimeInterval: 0.3)
                }
                for plan in filterdPlan  {
                    DispatchQueue.main.async{
                        switch plan.changeStatus{
                        case .toTurnOn:
                            print(plan.count)
                            self.stage.triangles[plan.index].status = .isOn
                        case .toTurnOff:
                            self.stage.triangles[plan.index].status = .isOff
                        case .toTurnOffWithAction:
                            self.stage.triangles[plan.index].status = .isOff
                            self.stage.triangles[plan.index].action = nil
                        }
                    }
                }
                counter += 1
            }
            Thread.sleep(forTimeInterval: 0.3)
            DispatchQueue.main.async {
                trianglesDeleteFeedback(plans: plans)
            }
            Thread.sleep(forTimeInterval: 0.5)
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
        var didSearched:Set<ModelCoordinate> = []
        var willSearch:Set<ModelCoordinate> = []
        willSearch.insert(coordinate)
        while !willSearch.isEmpty{
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
                if stage.triangles[index].status == .isOn || stage.triangles[index].status == .onAppear {
                    //アクションが入っている場合は、アクションに指定されたマスをOnにして、探索済みから取り除く
                    if let action = stage.triangles[index].action {
                        let actionCoordinate = action.actionCoordinate(from: searchingNow)
                        didSearched.subtract(actionCoordinate)
                        //アクションをおこなう座標のステータスを更新し、planに加える
                        coordinatesInStage(coordinates: actionCoordinate).map {
                            indexOfTrianglesInStage(coordinate: $0)!
                        }.filter{
                            stage.triangles[$0].status != .isOn && stage.triangles[$0].status != .onAppear
                        }.forEach{
                            plan.append(PlanOfChangeStatus(index: $0, count: counter, changeStatus: .toTurnOn))
                            stage.triangles[$0].status = .onAppear
                        }
                        plan.append(PlanOfChangeStatus(index: index, count: counter, changeStatus: .toTurnOffWithAction))
                        stage.triangles[index].action = nil
                        willSearch.formUnion(nextCoordinates)
    
                    }else{
                    plan.append(PlanOfChangeStatus(index: index, count: counter, changeStatus: .toTurnOff))
                    willSearch.formUnion(nextCoordinates)
                    }
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
        stage.triangles.firstIndex{ $0.coordinate == coordinate }
    }
    ///ステージ内にあるかどうかを返す
    private func isInStage(coordinate:ModelCoordinate) -> Bool{
        stage.triangles.contains{ $0.coordinate == coordinate }
    }
    ///ステージ内に含まれる座標を返す
    private func coordinatesInStage(coordinates: Set<ModelCoordinate>) -> Set<ModelCoordinate>{
        Set(coordinates.filter{ isInStage(coordinate: $0) })
    }
    ///ステータス変更の予定のセット
    struct PlanOfChangeStatus{
        let index:Int
        let count:Int
        let changeStatus:UpdateStatus
        
        enum UpdateStatus{
            case toTurnOn
            case toTurnOff
            case toTurnOffWithAction
        }
    }
}



