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
    var triangles: [TriangleViewModel] {
        var triangles: [TriangleViewModel] = []
        for (triangleY, arrangement) in arrangement.enumerated(){
            for triangleX in arrangement{
                let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOff, action: nil )
                    triangles.append(triangleModel)
            }
        }
        return triangles
    }
    var fieldLines: [TriLine] {
        triangles.flatMap {
            $0.triLine
        }
    }
    var fieldOutLines: [TriLine] {
        outLine(original: fieldLines)
    }
    //線が繋がるように並び替え新たな配列を返す、頂点を3つ以上共有している場合は機能しない
    private func sort(_ original: inout [TriLine]) -> [TriLine] {
        var sorted: [TriLine] = []
        guard original.count > 0 else {
            print(original.count)
            return []
        }
        sorted.append(original.removeFirst())
        while !original.isEmpty {
            if let index = original.firstIndex(where: {
                $0.start == sorted.last?.end
            }) {
                sorted.append(original.remove(at: index))
            } else if let index = original.firstIndex(where: {
                $0.end == sorted.last?.end
            }) {
                //
                original[index].reversed()
                sorted.append(original.remove(at: index))
            }
        }
        return sorted
    }
    //線の配列から重複部分を取り除き、外周部分を残す　重複が3つ以上の場合は機能しない
    private func outLine(original: [TriLine]) -> [TriLine] {
        var tranceformed: [TriLine] = []
        original.forEach { original in
            if let index = tranceformed.firstIndex(where: {
                $0 == original
            }) {
                tranceformed.remove(at: index)
            } else {
                tranceformed.append(original)
            }
        }
        return sort(&tranceformed)
    }
}

extension TriangleField {
    
    static let smallOnigiri = TriangleField(numberOfCell: 4, arrangement:
                                                [
                                                    [Int](3...5),
                                                    [Int](1...5),
                                                    [Int](0...4)
                                                ])
    static let smallHexagon = TriangleField(numberOfCell: 5, arrangement:
                                                [
                                                    [Int](3...7),
                                                    [Int](1...7),
                                                    [Int](0...6),
                                                    [Int](0...4)
                                                ])
    static let midiumOnigiri = TriangleField(numberOfCell: 4, arrangement:
                                                [
                                                    [Int](3...5),
                                                    [Int](1...5),
                                                    [Int](-1...5),
                                                    [Int](-2...4)
                                                ])
    static let largeHexagon = TriangleField(numberOfCell: 6, arrangement:
                                                [
                                                    [Int](3...9),
                                                    [Int](1...9),
                                                    [Int](-1...9),
                                                    [Int](-2...8),
                                                    [Int](-2...6),
                                                    [Int](-2...4)
                                                ])
}
