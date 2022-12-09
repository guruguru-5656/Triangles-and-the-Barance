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
    
    private var locked: Bool {
        itemModel.level == 0
    }
    
    private var itemColor: StageColor {
        locked ? .monochrome : gameModel.currentColor
    }
    
    private var selectableOpacity: Double {
        if locked {
            return 0.3
        }
        if gameModel.stageStatus.canUseItem(cost: itemModel.cost) {
            return 1
        }
        return 0.3
    }
  
    //アニメーション用プロパティ
    private var circleScale:Double {
        isSelected ? 1 : 1.4
    }
    
    private var circleOpacity:Double {
        isSelected ? 1 : 0
    }

    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                ZStack {
                    //アイテムの種類ごとに表示を出し分ける
                    switch itemModel.type{
                        
                    case .normal:
                        NormalActionView(stageColor: itemColor, size: size)
                    case .hourGlass:
                        ActionItemHourglassView(stageColor: itemColor, size: size)
                    case .triHexagon:
                        ActionItemTriHexagonView(stageColor: itemColor, size: size)
                    case .pyramid:
                        PyramidItemView(stageColor: itemColor, size: size)
                    case .shuriken:
                        ActionItemShurikenView(stageColor: itemColor, size: size)
                    case .hexagon:
                        ActionItemHexagonView(stageColor: itemColor, size: size)
                    case .horizon:
                        ActionItemHorizon(stageColor: itemColor, size: size)
                    case .hexagram:
                        ActionItemHexagramView(stageColor: itemColor, size: size)
                    }
                }
                    .opacity(selectableOpacity)
                if locked {
                    Image(systemName: "lock.square")
                        .resizable()
                        .foregroundColor(Color(white: 0.5))
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
        .padding(.top, size / 4)
    }
}

