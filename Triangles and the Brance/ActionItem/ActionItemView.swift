//
//  DragNormalItemView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///アイテムのビュー
struct ActionItemView: View {
    
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    @State var itemModel: ActionItemModel
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
            //アイテムの種類ごとに表示を出し分ける
            if let actionItem = itemModel.action{
                switch actionItem{

                case .normal:
                    NormalActionView(size: size)
                      
                case .pyramid:
                    PyramidItemView(size: size)
                case .hexagon:
                    //MARK: 仮のView
                    ActionItemHexagonView(size: size)
                }
            }
            Circle()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
                .frame(width: size, height: size)
                .scaleEffect(circleScale)
                .animation(.easeOut(duration: 0.2), value: circleScale)
                .opacity(circleOpacity)
                .animation(.easeOut(duration: 0.2), value: circleOpacity)
                .contentShape(Circle())
                .onTapGesture {
                    itemController.itemSelectAction(model: itemModel)
                }
                .transition(
                    .asymmetric(insertion: .opacity.combined(with: .move(edge: .trailing)),
                                removal: .opacity)
                )
        }
    }
}

