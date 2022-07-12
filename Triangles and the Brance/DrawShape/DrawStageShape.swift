//
//  DrawTriShape.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import SwiftUI

///頂点の座標系から描画を行う
struct DrawShapeFromVertexCoordinate: View{
    let coordinates:[TriangleVertexCoordinate]
    let scale: CGFloat
    var body: some View {
        Path{ path in
            path.move(to: coordinates[0].drawPoint.scale(scale))
            let linePoint = coordinates.dropFirst().map {
                $0.drawPoint.scale(scale)
            }
            linePoint.forEach{
                path.addLine(to: $0)
            }
            path.closeSubpath()
        }
    }
}

struct DrawShapeFromTriLines: View {
    let lines: [TriLine]
    let scale: CGFloat
    var body: some View {
        Path { path in
            let points = lines.map {
                $0.end.drawPoint.scale(scale)
            }
            path.move(to: lines.first!.start.drawPoint.scale(scale))
            path.addLines(points)
            path.closeSubpath()
        }
    }
}

struct DrawTriLine:Shape{
    init(line:TriLine,scale:CGFloat){
        startCoordinate = line.start
        endCoordinate = line.end
        self.scale = scale
    }
    init(start:TriangleVertexCoordinate, end:TriangleVertexCoordinate,scale:CGFloat){
        self.startCoordinate = start
        self.endCoordinate = end
        self.scale = scale
    }
    
    let startCoordinate:TriangleVertexCoordinate
    let endCoordinate:TriangleVertexCoordinate
    let scale:CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: startCoordinate.drawPoint.scale(scale))
        path.addLine(to: endCoordinate.drawPoint.scale(scale))
        return path
    }
}
//2つの頂点の座標を持つ線を表した構造体
struct TriLine: Hashable , Equatable{
    var start:TriangleVertexCoordinate
    var end:TriangleVertexCoordinate
    //startとendを入れ替えた場合も同値として扱う
    static func == (lhs: TriLine, rhs: TriLine) -> Bool {
        return lhs.start == rhs.start && lhs.end == rhs.end ||
        lhs.start == rhs.end && lhs.end == rhs.start
    }
    //線の配列から重複部分を取り除き、外周部分を残す　重複が3つ以上の場合は機能しない
    static func outLine(original: [TriLine]) -> [TriLine] {
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
        return tranceformed
    }
    //線が繋がるように並び替え新たな配列を返す、頂点を3つ以上共有している場合は機能しない
    static func sort(_ original: inout [TriLine]) -> [TriLine] {
        var sorted: [TriLine] = []
        guard var first = original.first else {
            return []
        }
        while let second = original.dropFirst().first(where: {
            $0.start == first.end || $0.end == first.end
        }) {
            sorted.append(original.removeFirst())
            first = second
        }
        return sorted
    }
}

