//
//  BaranceViewContloller.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/16.
//

import SwiftUI

class BaranceViewContloler: ObservableObject {
    private let angleAnimation = Animation.timingCurve(0.3, 0.5, 0.6, 0.8, duration: 0.5)
    private var targetDeleteCount: Double
    private var deleteCount: Double
    @Published var clearCircleIsOn = false
    @Published var angle: Double = Double.pi/16
    @Published var showDeleteCountText = false
    @Published var isTriangleHiLighted = false
    @Published var deleteCountNow = 0
    @Published var clearPersent: Double = 0

    init(deleteCount: Int, targetDeleteCount: Int) {
        self.deleteCount = Double(deleteCount)
        self.targetDeleteCount = Double(targetDeleteCount)
    }
    
}
