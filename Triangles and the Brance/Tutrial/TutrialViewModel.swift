//
//  TutrialModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/14.
//

import Foundation
import SwiftUI

final class TutrialViewModel: StageModel {
    
    @Published private(set) var description = Description()
    
    init() {
        super.init(dataStore: TutrialData())
    }
    
    func continueTutrial(_ flag: TutrialContinueFlag) {
        guard flag == description.flag else {
            return
        }
        if description.canContinue {
            description.next()
        } else {
            exitTutrial()
        }
    }
    
    func exitTutrial() {
        isPresented = false
    }
    
    override func triangleDidDeleted(count: Int) {
        self.deleteCount += count
        energy += count
        life -= 1
        if maxCombo < count {
            maxCombo = count
        }
        gameEventPublisher.send(.init(.triangleDeleted, value: count))
        //元の処理からゲームクリア等のイベントを削除
        continueTutrial(.triangleDeleted)
    }
    
    override func itemSelect(model: ActionItemModel) {
        guard life > 0 else {
            return
        }
        if model.id == selectedItem?.id {
            selectedItem = nil
            return
        }
        if model.cost ?? .max <= energy {
            selectedItem = model
            itemSelectSound?.play()
            //チュートリアルを進める判定を追加
            continueTutrial(.itemSelected)
        }
        return
    }
    
    override func useItem() {
        guard let selectedItem = selectedItem else {
            return
        }
        life -= 1
        energy -= selectedItem.cost!
        self.selectedItem = nil
        gameEventPublisher.send(.init(.itemUsed, value: selectedItem.cost!))
        //元の処理からゲームオーバーの処理を削除
        continueTutrial(.itemUsed)
    }
    
    struct Description {
        //これでチュートリアルの内容を表す
        static private let object: [Object] = [
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .down,
                   text: "チュートリアルを開始します。",
                   flag: .next),
            Object(tutrialGeometryKey: .triangleView,
                   tutrialTextPosition: .down,
                   text: "フィールド上にあるいづれかの三角形をタップしてみましょう。",
                   flag: .triangleDeleted),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .down,
                   text: "タップすると隣接している三角形を巻き込みながら消えます。",
                   flag: .next),
            Object(tutrialGeometryKey: .baranceView,
                   tutrialTextPosition: .down,
                   text: "この天秤には2つ数字が書かれています。",
                   flag: .next),
            Object(tutrialGeometryKey: .baranceView,
                   tutrialTextPosition: .down,
                   text: "左が現在消した三角形の数、右が目標数です。",
                   flag: .next),
            Object(tutrialGeometryKey: .baranceView,
                   tutrialTextPosition: .down,
                   text: "そして、この目標数以上三角形を消すとステージクリアになります。",
                   flag: .next),
            Object(tutrialGeometryKey: .lifeView,
                   tutrialTextPosition: .down,
                   text: "ただし、何かアクションをするごとに行動回数が減っていきます。",
                   flag: .next),
            Object(tutrialGeometryKey: .lifeView,
                   tutrialTextPosition: .down,
                   text: "ステージをクリアできず、回数がなくなってしまうとゲームオーバーです。",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "ここにはアイテムが表示されています。",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "アイテムを使うことでフィールドにある三角形を復活させることができます。",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "使用するにはそれぞれのアイテムの下に表示されているコスト分のエネルギーが必要です。",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "バッテリーアイコン右の数字がエネルギーを表しており、三角形を消すことによってチャージされます。",
                   flag: .next),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "アイテムを使用してみましょう。一番左の三角形のアイコンをタップしてください。",
                   flag: .itemSelected),
            Object(tutrialGeometryKey: .triangleView,
                   tutrialTextPosition: .down,
                   text: "フィールド上の空いた場所をタップするとそこを起点に三角形が復活します。",
                   flag: .itemUsed),
            Object(tutrialGeometryKey: .itemView,
                   tutrialTextPosition: .up,
                   text: "効果範囲はアイテムによって異なり、アイテムのアイコンを長押しすることで確認できます。",
                   flag: .next),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .up,
                   text: "三角形をタップして消すこと、アイテムを使用することをうまく組み合わせてクリアを目指しましょう。",
                   flag: .next),
            Object(tutrialGeometryKey: nil,
                   tutrialTextPosition: .up,
                   text: "以上でチュートリアル終了となります。お疲れ様でした。",
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
