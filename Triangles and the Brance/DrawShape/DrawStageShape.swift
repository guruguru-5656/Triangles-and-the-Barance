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
    @State var lines: [TriLine]
    let scale: CGFloat
    var maxY: CGFloat {
        let max = lines.map {
            $0.start.drawPoint.scale(scale).y
        }.max() ?? 0
        return max
    }
    var body: some View {
        
        Path { path in
            let points = lines.map {
                $0.end.drawPoint.scale(scale)
            }
            guard let firstLine = lines.first else {
                return
            }
            path.move(to: firstLine.start.drawPoint.scale(scale))
            path.addLines(points)
            path.closeSubpath()
        }
        .frame(height: maxY)
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
struct TriLine: Hashable , Identifiable {
    var start:TriangleVertexCoordinate
    var end:TriangleVertexCoordinate
    let id = UUID()
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
        return sort(&tranceformed)
    }
    mutating func reversed() {
        let copy = start
        start = end
        end = copy
    }
    //線が繋がるように並び替え新たな配列を返す、頂点を3つ以上共有している場合は機能しない
    private static func sort(_ original: inout [TriLine]) -> [TriLine] {
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
}

