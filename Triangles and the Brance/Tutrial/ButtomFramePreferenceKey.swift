//
//  ButtomFramePreferenceKey.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/26.
//

import SwiftUI

struct ButtonFramePreferenceKey: PreferenceKey {
    typealias Value = Anchor<CGRect>?
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        guard nextValue() != nil else {
            return
        }
        value = nextValue()
    }
}
