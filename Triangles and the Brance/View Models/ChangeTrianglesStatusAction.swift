//
//  TriangleDeleteAction.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/19.
//

import Foundation

///ステージ内のTriangleに対するアクションを実行する
///処理を行う場所を特定し、カウンターの場所と一緒にステージ側に投げる
class ChangeTriangleStatusAction{
    
    init(item:ActionItemModel?,stageItems:[ActionItemModel], triangles:[TriangleViewModel]){
        self.selectedActionItem = item
        self.actionItems = stageItems
        self.triangles = triangles
    }
    var selectedActionItem:ActionItemModel?
    var actionItems:[ActionItemModel]
    var triangles:[TriangleViewModel]
    
    ///Triangleの消去の順番を求めて、deleteTriangleActionを呼び出す
    func deleteTriangles(coordinate:ModelCoordinate, action:ActionType?,completion:(OnOrOff,Int,Int) -> Void) throws{
        
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
                if !triangles.contains(where: { $0.coordinate == searchingNow}) {
                    continue
                }
                //インデックスの取得チェック
                guard let index = indexOfTrianglesInStage(coordinate: searchingNow)
                else{ throw StageError.triangleIndexError }
                
                
                if triangles[index].status == .isOn || triangles[index].status == .onAppear{
                    print(willSearch.count)
                    
                    //アクションが入っている場合は、アクションに指定されたマスをOnにして、探索済みから取り除く
                    if let action = triangles[index].action{
                        let actionCoordinate = actionCoordinate(action: action, from: searchingNow)
                        
                        actionCoordinate.compactMap{
                            indexOfTrianglesInStage(coordinate: $0)
                        }.forEach{
                            //ステージに通知する
                            completion(.turnOn,$0,counter)
                        }
                        //探索予定にオンにした座標の中から隣接する座標を加える
                        let nextCoordinate = nextCoordinates(coordinate: searchingNow)
                        willSearch.formUnion(actionCoordinate.union(nextCoordinate))
                        didSearched.subtract(actionCoordinate)
                        counter += 1
                    }
                    //ステージに通知する
                    completion(.turnOff,index,counter)
                    
                    let nextCoordinate = nextCoordinates(coordinate: searchingNow)
                    willSearch.formUnion(nextCoordinate)
                }
                
                willSearch.subtract(didSearched)
            }
            counter += 1
        }
    }
    
    ///アクションごとにステージ内の書き換えを行う場所を返す
    private func actionCoordinate(action:ActionType, from coordinate:ModelCoordinate) ->Set<ModelCoordinate>{
        switch action{
        case .triforce:
            return nextCoordinates(coordinate: coordinate)
        }
    }
    
    ///Triangleの座標で検索を行い、ステージ配列のインデックスを取得する
    private func indexOfTrianglesInStage(coordinate:ModelCoordinate) -> Int?{
        triangles.firstIndex{ $0.coordinate == coordinate }
    }
    ///ステージ内の隣接した座標を取得する
    private func nextCoordinates(coordinate:ModelCoordinate) -> Set<ModelCoordinate>{
        
        //隣接する座標を取得する
        var nextCoordinates:[ModelCoordinate] = []
        let remainder = coordinate.x % 2
        if remainder == 0{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y-1),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y),])
        }else{
            nextCoordinates.append(contentsOf: [
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x+1, y:coordinate.y),
                ModelCoordinate(x:coordinate.x-1, y:coordinate.y+1),])
        }
        //ステージ内に入っているか確認し、格納
        var nextInStage:Set<ModelCoordinate> = []
        for nextCoordinate in nextCoordinates {
            if triangles.map({$0.coordinate})
                .contains(where: {$0 == nextCoordinate}) == true{
                nextInStage.insert(nextCoordinate)
            }
        }
        return nextInStage
    }
    
}

enum OnOrOff{
    case turnOn
    case turnOff
}
