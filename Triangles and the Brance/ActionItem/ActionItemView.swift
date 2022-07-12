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
    @Binding var itemModel: ActionItemModel
    @ObservedObject var itemController = GameModel.shared.itemController
    let size:CGFloat
    var selectableOpacity: Double {
        if itemModel.level == 0 {
            return 0.2
        }
        if itemModel.count > 0 || itemModel.cost ?? .max <= itemController.energy {
            return 1
        } else {
            return 0.5
        }
    }
    var itemText: String {
        if itemModel.count > 0 {
            return "×\(itemModel.count)"
        } else if let cost = itemModel.cost {
            return String(cost)
        } else {
            return ""
        }
    }
    //アニメーション用プロパティ
    var circleScale:Double{
        guard let stageItem = itemController.selectedItem
        else { return 1.4 }
        if stageItem.id == itemModel.id {
            return 1
        }else{
            return 1.4
        }
    }
    var circleOpacity:Double{
        guard let stageItem = itemController.selectedItem
        else { return 0 }
        if stageItem.id == itemModel.id{
            return 1
        }else{
            return 0
        }
    }

    var body: some View {
        
        ZStack {
            Section {
            //アイテムの種類ごとに表示を出し分ける
                switch itemModel.type{
                    
                case .normal:
                    NormalActionView(size: size)
                case .pyramid:
                    PyramidItemView(size: size)
                case .hexagon:
                    ActionItemHexagonView(size: size)
                case .hexagram:
                    ActionItemHexagramView(size: size)
                }
                Text(itemText)
                    .offset(x: 0, y: size * 2/3)
                    .font(Font(UIFont.monospacedSystemFont(ofSize: size * 2/5, weight: .regular)))
            }
            .opacity(selectableOpacity)
            if itemModel.level == 0 {
                Image(systemName: "lock.square")
                    .resizable()
                    .foregroundColor(Color(white: 0.4))
                    .frame(width: size * 0.5 , height: size * 0.5)
            }
            Circle()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 1)
                .frame(width: size , height: size)
                .scaleEffect(circleScale)
                .animation(.easeOut(duration: 0.2), value: circleScale)
                .opacity(circleOpacity)
                .animation(.easeOut(duration: 0.2), value: circleOpacity)
                .contentShape(Circle())
                .onTapGesture {
                    itemController.itemSelect(model: itemModel)
                }
        }
        .padding(.top, size / 4)
    }
}

