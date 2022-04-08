//
//  DragNormalItemView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import SwiftUI

///アイテムのビュー
struct ActionItemView: View {
    @EnvironmentObject var game:GameModel
    let item:ActionItemViewModel
    let size:CGFloat
    //アニメーション用プロパティ
    var circleScale:Double{
        guard let stageItem = game.selectedActionItem
        else{ return 2 }
        if stageItem.id == self.item.id {
            return 1
        }else{
            return 2
        }
    }
    var circleOpacity:Double{
        guard let stageItem = game.selectedActionItem
        else{ return 0 }
        if stageItem.id == self.item.id{
            return 1
        }else{
            return 0
        }
    }

    var body: some View {
        ZStack{
            Circle()
                .stroke(game.currentColor.heavy, lineWidth: 1)
                .frame(width: size, height: size)
                .scaleEffect(circleScale)
                .animation(Animation.easeOut(duration: 0.2),value:circleScale)
                .opacity(circleOpacity)
                .animation(Animation.easeOut(duration: 0.2),value:circleOpacity)
                .overlay{
                    //アイテムの種類ごとに表示を出し分ける
                    if let actionItem = item.action{
                        switch actionItem{
                        case .normal:
                            NormalActionView(size: size)
                        case .triforce:
                            TriforceActionView(size: size)
                        }
                    }
                }
                .contentShape(Circle())
                .onTapGesture{
                    if game.selectedActionItem == nil{
                        game.selectedActionItem = item
                    }else{
                        game.selectedActionItem = nil
                    }
                }
        }
        .transition(.asymmetric(insertion: .offset(x: 500, y: 0).animation(.linear(duration: 1)),
                                removal: .opacity.animation(.easeIn(duration: 0.2))
                                    .combined(with: .scale(scale: 1.1)
                                                .animation(.easeIn(duration: 0.2)))))
    }
}

