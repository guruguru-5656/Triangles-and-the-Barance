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
struct TriangleTapAction{
    
    init(stage:StageModel,index:Int){
        self.triangles = stage.triangles
        self.actionItems = stage.actionItems
        
        trianglesTapAction(index: index)
    }
    
    //インスタンス化した際にこのプロパティがセットされる
    var plans:[PlanOfChangeStatus] = []
    var additionalItem:ActionItemModel?
   
    ///ステージ内にあるTriangleの配列、Triangleの更新は一部ずつ行うため、直接渡さない
    private var triangles:[TriangleViewModel]
    private var actionItems:[ActionItemModel]
   
    ///アクションの一覧、コストが高い順に格納されている
    private var actionsForGenerateTriangle:[ActionType] = ActionType.allCases.filter{ $0.cost != nil }.sorted{ $0.cost! > $1.cost! }
    
    ///Triangleのステータスを参照し、アクションを実行するか判断、自身のプロパティを書き換える
    private mutating func trianglesTapAction(index:Int){
        
        let coordinate = triangles[index].coordinate
        do{
            
            self.plans = try deleteTriangles(coordinate: coordinate, action: triangles[index].action)
            
            let deleteCount = plans.filter{
                $0.changeStatus == .toTurnOff || $0.changeStatus == .toTurnOffWithAction
            }.count
            
            //一定数以上消していた場合は新しくItemを追加する
            for action in actionsForGenerateTriangle{
                if deleteCount >= action.cost!{
                    self.additionalItem = ActionItemModel(action: action)
                    break
                }
            }
        }catch{
            print("ERROR:\(error)")
        }
    }
    
    
    ///Triangleの消去の順番を求める
    private mutating func deleteTriangles(coordinate:ModelCoordinate, action:ActionType?) throws ->   [PlanOfChangeStatus]{
        
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
                
                if triangles[index].status == .isOn{
                    //アクションが入っている場合は、アクションに指定されたマスをOnにして、探索済みから取り除く
                    if let action = triangles[index].action{
                        
                        let actionCoordinate = action.actionCoordinate(from: searchingNow)
                        
                        didSearched.subtract(actionCoordinate)
                        
                        //アクションをおこなう座標のステータスを更新し、planに加える
                        coordinatesInStage(coordinates: actionCoordinate).map{
                            indexOfTrianglesInStage(coordinate: $0)!
                        }.forEach{
                            triangles[$0].status = .isOn
                            plan.append(PlanOfChangeStatus(index: $0, count: counter, changeStatus: .toTurnOn))
                        }
                        
                        plan.append(PlanOfChangeStatus(index: index, count: counter, changeStatus: .toTurnOffWithAction))
                        
                        triangles[index].action = nil
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
    struct PlanOfChangeStatus{
        let index:Int
        let count:Int
        let changeStatus:ChangeStatus
        
        enum ChangeStatus{
            case toTurnOn
            case toTurnOff
            case toTurnOffWithAction
        }
    }
}



