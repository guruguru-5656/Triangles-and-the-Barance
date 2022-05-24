//
//  ItemController.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/26.
//

import SwiftUI

class ItemController: PlayingData, ObservableObject {
    
    @Published var actionItems: [ActionItem] = []
    @Published var selectedItem: ActionItem?
    @Published var progressingTapActionItem: FaceTapActionItemProgressModel?
    private var actionsForGenerateTriangle:[ActionType] = ActionType.allCases.filter{ $0.defaultCost != nil }.sorted{ $0.defaultCost! > $1.defaultCost! }
    
    
    func itemAction(position: Position) -> [[(Int, Int)]]{
        guard let item = selectedItem else {
            return []
        }
        //positionがactionで指定された場所でなければ選択状態を解除
        guard item.action.position == position else{
            selectedItem = nil
            return []
        }
     
        switch item.action {
            //normalのアクションはその他のアイテムとは別の管理になっている
        case .normal:
            guard GameModel.shared.parameter.normalActionCount != 0 else{
                print("カウントゼロの状態で選択されている")
                return []
            }
            GameModel.shared.parameter.normalActionCount -= 1
            
            
        default:
          
            let indexOfItem = actionItems.firstIndex {
                $0.id == item.id
            }
            guard let indexOfItem = indexOfItem else {
                print("アイテムのインデックス取得エラー")
                return []
            }
           
            _ = withAnimation {
                actionItems.remove(at: indexOfItem)
            }
           
        }
        selectedItem = nil
        actionAnimation()
        return item.action.actionCoordinate
    }
    
    private func actionAnimation() {
        
    }
    
    ///一定数以上消していた場合は新しくItemを追加する
    func appendStageItems(count: Int) {
        for action in actionsForGenerateTriangle{
            if count >= action.defaultCost!{
                withAnimation{
                    actionItems.append(ActionItem(action: action))
                }
                break
            }
        }
    }
    
    //ゲームリセット時の挙動
    func resetParameters(defaultParameter: DefaultParameters) {
        actionItems = []
        selectedItem = nil
        progressingTapActionItem = nil
    }
    //ステージクリア時の挙動
    func setParameters(defaultParameter: DefaultParameters) {
        //現状何もする予定なし
    }
    
    
}
