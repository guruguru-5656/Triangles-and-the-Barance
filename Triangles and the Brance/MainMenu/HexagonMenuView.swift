//
//  HexagonMenuView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/01.
//

import SwiftUI

struct HexagonMenuView: View {
    let field = TriangleField.miniHexagon
    let cellModels: [MainMenuCellModel]
    
    init(cellModels: [MainMenuCellModel]) {
        self.cellModels = cellModels
    }
    
    var body: some View {
        GeometryReader { geometry in
            let length = geometry.size.width / CGFloat(field.numberOfCell)
            ZStack {
                //背景
                DrawShapeFromTriLines(lines: field.fieldOutLines, scale: length)
                    .foregroundColor(.backgroundLightGray)
                    .scaleEffect(1.1)
                //背景の線部分
                ForEach(field.fieldLines){ line in
                    DrawTriLine(line: line, scale: length)
                        .stroke(Color.heavyRed, lineWidth: 1)
                }
                //メニュー本体
                ForEach(cellModels) { model in
                    TriangleButtonView(text: model.text, imageName: model.imageName, coordinate: model.coordinate, action: model.action, length: length)
                }
            }
            .frame(height:geometry.size.width * sqrt(3) / 2)
        }
    }
}

struct HexagonMenuView_Previews: PreviewProvider {
    static var previews: some View {
        HexagonMenuView(cellModels: [MainMenuCellModel(menu: .upgrade, action: {})])
    }
}

