//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI


///Triangleのモデルデータ
struct TriangleViewModel: Identifiable {
    let id = UUID()
    var coordinate: TriangleCenterCoordinate
    var status: ViewStatus

    init(x: Int,y: Int, status: ViewStatus) {
        coordinate = TriangleCenterCoordinate(x: x, y: y)
        self.status = status
    }
    
    var reversed: Bool {
        let remainder = coordinate.x % 2
        if remainder == 0 {
            return true
        } else {
            return false
        }
    }
    ///対応する頂点の座標系
    var vertexCoordinate: [TriangleVertexCoordinate] {
        if reversed {
            return [TriangleVertexCoordinate(x: coordinate.x/2, y: coordinate.y),
                    TriangleVertexCoordinate(x: coordinate.x/2 + 1, y: coordinate.y),
                    TriangleVertexCoordinate(x: coordinate.x/2, y: coordinate.y + 1)]
        } else {
            return [TriangleVertexCoordinate(x: (coordinate.x+1)/2, y: coordinate.y),
                    TriangleVertexCoordinate(x: (coordinate.x+1)/2 - 1, y: coordinate.y + 1),
                    TriangleVertexCoordinate(x: (coordinate.x+1)/2, y: coordinate.y + 1)]
        }
    }
    
    var triLine: [TriLine] {
        return [
            TriLine(start: vertexCoordinate[0], end: vertexCoordinate[1]),
            TriLine(start: vertexCoordinate[1], end: vertexCoordinate[2]),
            TriLine(start: vertexCoordinate[2], end: vertexCoordinate[0])
        ]
    }
}

extension TriangleViewModel: Codable {
    enum CodingKeys: String, CodingKey {
        case coordinate
        case status
    }
}

///現在の状態を表す、これにより入力の受付の判断や、描画の状態を変更する
enum ViewStatus: Codable {
    case onAppear
    case isOn
    case isDisappearing
    case isOff
}
