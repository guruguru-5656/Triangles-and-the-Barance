//
//  TutrialViewSpace.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/14.
//

import SwiftUI

struct TutrialViewSpace: ViewModifier {
    let key: TutrialGeometryKey
    func body(content: Content) -> some View {
        content
            .anchorPreference(key: TutrialPreferenceKey.self,
                              value: .bounds,
                              transform: { [key : $0] })
    }
}

struct TutrialPreferenceKey: PreferenceKey {
    typealias Value = [TutrialGeometryKey:Anchor<CGRect>]
    static var defaultValue: [TutrialGeometryKey:Anchor<CGRect>] = [:]
    static func reduce(value: inout Self.Value, nextValue: () -> Self.Value) {
        value.merge(nextValue()) { $1 }
    }
}

enum TutrialGeometryKey {
    case triangleView
    case itemView
    case baranceView
    case lifeView
}
