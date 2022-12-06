//
//  DragNormalItemView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///アイテムのビュー
struct ActionItemView: View {
    
    @EnvironmentObject private var gameModel: GameModel
    @Binding var itemModel: ActionItemModel
    let size:CGFloat
    
    private var isSelected: Bool {
        itemModel.id == gameModel.selectedItem?.id
    }
    
    private var selectableOpacity: Double {
        if itemModel.level == 0 {
            return 0.2
        }
        if gameModel.stageStatus.canUseItem(cost: itemModel.cost) {
            return 1
        }
        return 0.5
    }
  
    //アニメーション用プロパティ
    var circleScale:Double {
        isSelected ? 1 : 1.4
    }
    
    var circleOpacity:Double {
        isSelected ? 1 : 0
    }

    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                //アイテムの種類ごとに表示を出し分ける
                switch itemModel.type{
                    
                case .normal:
                    NormalActionView(stageColor: gameModel.currentColor, size: size)
                case .hourGlass:
                    ActionItemHourglassView(stageColor: gameModel.currentColor, size: size)
                case .triHexagon:
                    ActionItemTriHexagonView(stageColor: gameModel.currentColor, size: size)
                case .pyramid:
                    PyramidItemView(stageColor: gameModel.currentColor, size: size)
                case .shuriken:
                    ActionItemShurikenView(stageColor: gameModel.currentColor, size: size)
                case .hexagon:
                    ActionItemHexagonView(stageColor: gameModel.currentColor, size: size)
                case .horizon:
                    ActionItemHorizon(stageColor: gameModel.currentColor, size: size)
                case .hexagram:
                    ActionItemHexagramView(stageColor: gameModel.currentColor, size: size)
                    
                }
                if itemModel.level == 0 {
                    Image(systemName: "lock.square")
                        .resizable()
                        .foregroundColor(Color(white: 0))
                        .frame(width: size * 0.5 , height: size * 0.5)
                }
                Circle()
                    .stroke(gameModel.currentColor.heavy, lineWidth: 1)
                    .frame(width: size , height: size)
                    .scaleEffect(circleScale)
                    .animation(.easeOut(duration: 0.2), value: circleScale)
                    .opacity(circleOpacity)
                    .animation(.easeOut(duration: 0.2), value: circleOpacity)
                    .contentShape(Circle())
            }
            Text(String(itemModel.cost))
                .font(Font(UIFont.monospacedSystemFont(ofSize: size * 2/5, weight: .regular)))
        }
        .opacity(selectableOpacity)
        .padding(.top, size / 4)
    }
}

