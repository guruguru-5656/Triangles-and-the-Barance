//
//  TutrialModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/14.
//

import Foundation
import SwiftUI

final class TutrialViewModel: GameModel {
    
    @Published private(set) var description = Description()
    @Published private(set) var isPresented = true
    
    init() {
        super.init(dataStore: TutrialData())
    }
    
    func continueTutrial(_ flag: TutrialContinueFlag) {
        guard flag == description.flag else {
            return
        }
        if description.canContinue {
            if flag == .next {
                soundPlayer.play(sound: .selectSound)
            }
            description.next()
        } else {
            soundPlayer.play(sound: .decideSound)
            exit()
        }
    }
    
    func exit() {
        withAnimation {
            isPresented = false
        }
    }
    
    override func triangleDidDeleted(count: Int) {
        stageScore.triangleDidDeleted(count: count)
        _ = stageStatus.triangleDidDeleted(count: count)
        //元の処理からゲームクリア等のイベントを削除
        continueTutrial(.triangleDeleted)
    }
    
    override func itemSelect(model: ActionItemModel) {
        if model.id == selectedItem?.id {
            selectedItem = nil
            return
        }
        if stageStatus.canUseItem(cost: model.cost) {
            selectedItem = model
            soundPlayer.play(sound: .selectSound)
            //チュートリアルを進める判定を追加
            continueTutrial(.itemSelected)
        }
        return
    }
    
    override func itemUsed() {
        super.itemUsed()
        continueTutrial(.itemUsed)
    }
    
    struct Description {
        //これでチュートリアルの内容を表す
        static private let object: [Object] = [
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .down,
                   text: "チュートリアルを開始します",
                   flag: .next),
            Object(tutrialGeometryKey: .triangleView,
                   tutrialTextPosition: .down,
                   text: "フィールド上にあるいづれかの三角形をタップしてみましょう",
                   flag: .triangleDeleted),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .down,
                   text: "タップすると繋がっている三角形が連鎖しながら消えます",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "ここにはアイテムが表示されています",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "アイテムを使うことでフィールドに三角形を配置できます",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "使用するにはそれぞれのアイテムに対応するエネルギーが必要です",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "必要数はアイテムの下に表示されています",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "上の段のゲージがエネルギーを表しており、三角形を消すことでチャージされます",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "アイテムを使用してみましょう\n一番左の三角形のアイテムをタップしてください",
                   flag: .itemSelected),
            Object(tutrialGeometryKey: .triangleView,
                   tutrialTextPosition: .down,
                   text: "フィールド上の空いた場所をタップしてください",
                   flag: .itemUsed),
            Object(tutrialGeometryKey: .triangleView,
                   tutrialTextPosition: .down,
                   text: "タップした箇所に三角形が配置されます",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "効果範囲はアイテムによって異なります",
                   flag: .next),
            Object(tutrialGeometryKey: .baranceView,
                   tutrialTextPosition: .down,
                   text: "この天秤には2つ数字が書かれています",
                   flag: .next),
            Object(tutrialGeometryKey: .baranceView,
                   tutrialTextPosition: .down,
                   text: "左が現在消した三角形の数、右がクリアに必要な数です",
                   flag: .next),
            Object(tutrialGeometryKey: .lifeView,
                   tutrialTextPosition: .down,
                   text: "「三角形を消す」「アイテムを使用する」の二つの行動をするごとにターンが減っていきます",
                   flag: .next),
            Object(tutrialGeometryKey: .lifeView,
                   tutrialTextPosition: .down,
                   text: "ステージをクリアできず、ターンがなくなってしまうとゲームオーバーです",
                   flag: .next),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .up,
                   text: "大量に連鎖させて消すと高得点となり、より高いスコアが獲得できます",
                   flag: .next),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .up,
                   text: "スコアはポイントに換算され、そのポイントと引き換えにいくつかの機能を解放できます",
                   flag: .next),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .up,
                   text: "アイテムを使ってフィールドをまとめることがゲームクリアへの近道です",
                   flag: .next),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .up,
                   text: "以上でチュートリアル終了となります\nお疲れ様でした",
                   flag: .next)
        ]
        
        //viewに渡すチュートリアルを表した情報
        var geometryKey: TutrialGeometryKey? {
            TutrialViewModel.Description.object[counter].tutrialGeometryKey
        }
        var textPosition: TutrialTextPosition? {
            TutrialViewModel.Description.object[counter].tutrialTextPosition
        }
        var text: String {
            TutrialViewModel.Description.object[counter].text
        }
        var flag: TutrialContinueFlag {
            TutrialViewModel.Description.object[counter].flag
        }
        //次のチュートリアルがあるかどうかを表す
        var canContinue: Bool {
            TutrialViewModel.Description.object.count - 1 > counter
        }
        
        mutating func next() {
            counter += 1
        }
        
        private var counter: Int = 0

        private struct Object {
            let tutrialGeometryKey: TutrialGeometryKey?
            let tutrialTextPosition: TutrialTextPosition?
            let text: String
            let flag: TutrialContinueFlag
        }
    }
}

enum TutrialTextPosition {
    case up
    case down
}

enum TutrialContinueFlag {
    case triangleDeleted
    case itemSelected
    case itemUsed
    case next
}
