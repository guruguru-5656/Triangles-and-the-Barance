//
//  TriangleField.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/12.
//

import Foundation
import SwiftUI

struct TriangleField {
    let numberOfCell: Int
    let arrangement: [[Int]]
}

extension TriangleField {
    static let largeHexagon = TriangleField(numberOfCell: 6, arrangement:
                                                [
                                                    [Int](3...9),
                                                    [Int](1...9),
                                                    [Int](-1...9),
                                                    [Int](-2...8),
                                                    [Int](-2...6),
                                                    [Int](-2...4)
                                                ])
    static let smallHexagon = TriangleField(numberOfCell: 4, arrangement:
                                                [
                                                    [Int](3...5),
                                                    [Int](1...5),
                                                    [Int](0...4)
                                                ])
}
