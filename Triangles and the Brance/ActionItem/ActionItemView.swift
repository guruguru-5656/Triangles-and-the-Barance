//
//  DragNormalItemView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///アイテムのビュー
struct ActionItemView: View {
    @EnvironmentObject var gameModel:GameModel
    @State var itemModel: ActionItem
    @ObservedObject var itemController = GameModel.shared.itemController
    let size:CGFloat
    //アニメーション用プロパティ
    var circleScale:Double{
        guard let stageItem = itemController.selectedItem
        else{ return 2 }
        if stageItem.id == itemModel.id {
            return 1
        }else{
            return 2
        }
    }
    
    var circleOpacity:Double{
        guard let stageItem = itemController.selectedItem
        else{ return 0 }
        if stageItem.id == itemModel.id{
            return 1
        }else{
            return 0
        }
    }
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(gameModel.currentColor.heavy, lineWidth: 1)
                .frame(width: size, height: size)
                .scaleEffect(circleScale)
                .animation(.easeOut(duration: 0.2), value: circleScale)
                .opacity(circleOpacity)
                .animation(.easeOut(duration: 0.2), value: circleOpacity)
                .overlay{
                    //アイテムの種類ごとに表示を出し分ける
                    if let actionItem = itemModel.action{
                        switch actionItem{
                        case .normal:
                            NormalActionView(size: size)
                        case .pyramid:
                            PyramidItemView(size: size)
                        }
                    }
                }
                .contentShape(Circle())
                .onTapGesture {
                    if itemController.selectedItem == nil{
                        if itemModel.action == .normal && gameModel.parameter.normalActionCount == 0 {
                            return
                        }
                        itemController.selectedItem = itemModel
                    }else{
                        itemController.selectedItem = nil
                    }
                }
                .transition(
                    .asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)),
                                removal: .opacity)
                )
        }
    }
}

