//
//  DescriptionView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/13.
//

import SwiftUI

struct DescriptionView: View {
    let field: TriangleField = TriangleField.largeHexagon
    let actionType: ActionType
    var originalCoordinate: StageCoordinate {
        switch actionType.position {
        case .center:
            return  TriangleCenterCoordinate(x: 4, y: 2)
        case .vertex:
            return TriangleVertexCoordinate(x: 2, y: 3)
        }
    }
    var effectCoordinates: [TriangleCenterCoordinate] {
        originalCoordinate.relative(coordinates: actionType.actionCoordinate).flatMap { $0 }.filter{
            effectCoordinate in
            field.triangles.contains {
                $0.coordinate == effectCoordinate
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let viewSize = geometry.size.width / CGFloat(field.numberOfCell)
            ZStack(alignment: .top){
                //背景
                DrawShapeFromTriLines(lines: field.fieldOutLines, scale: viewSize)
                    .foregroundColor(.backgroundLightGray)
                    .scaleEffect(1.2)
                //背景の線部分
                ForEach(field.fieldLines){ line in
                    DrawTriLine(line: line, scale: viewSize)
                        .stroke(.gray, lineWidth: 1)
                }
                //アイテムの効果範囲を表す
                ForEach(effectCoordinates, id: \.self){ coordinate in
                    DrawTriangleFromCenter()
                        .fill(Color.lightGreen)
                        .frame(width: viewSize, height: viewSize / sqrt(3))
                        .scaleEffect(0.95)
                        .rotationEffect(coordinate.x % 2 == 0 ? Angle(degrees:0) : Angle(degrees: 180))
                        .position(coordinate.drawPoint.scale(viewSize))
                }
                if actionType.position == .center {
                DrawTriangleFromCenter()
                    .fill(Color.heavyGreen)
                    .frame(width: viewSize, height: viewSize / sqrt(3))
                    .scaleEffect(0.95)
                    .rotationEffect(originalCoordinate.x % 2 == 0 ? Angle(degrees:0) : Angle(degrees: 180))
                    .position(originalCoordinate.drawPoint.scale(viewSize))
                }
                if actionType.position == .vertex {
                    Circle()
                        .fill(Color.heavyGreen)
                        .frame(width: viewSize * 0.7, height: viewSize * 0.7)
                        .position(originalCoordinate.drawPoint.scale(viewSize))
                }
            }
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(actionType: .normal )
    }
}
