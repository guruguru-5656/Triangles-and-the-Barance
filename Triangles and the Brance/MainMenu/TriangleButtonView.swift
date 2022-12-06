//
//  HexagonMenuCellView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/01.
//

import SwiftUI


struct TriangleButtonView: View {
    let text: String
    let imageName: String
    let coordinate: TriangleCenterCoordinate
    let action: () -> Void
    let length: CGFloat
    //三角形からはみ出さないようにフレームの高さを設定
    private var height: CGFloat {
        length / sqrt(3)
    }
    ///与えられた座標のX座標をもとに回転するかどうか判断する
    private var isRotated: Bool {
        let remainder = coordinate.x % 2
        return remainder == 0
    }
  
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if isRotated {
                Text(text)
                    .font(.title)
                    .frame(width: length, height: height * 0.5)
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .frame(width: length * 2/3, height: height * 0.5)
            } else {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .frame(width: length * 2/3, height: height * 0.5)
                Text(text)
                    .font(.title)
                    .frame(width: length, height: height * 0.5)
            }
        }
        .frame(width: length, height: height)
        .position(coordinate.drawPoint.scale(length))
        .mask {
            DrawTriangleFromCenter()
                .frame(width: length, height: height)
                .rotationEffect(isRotated ? Angle(degrees: 0) : Angle(degrees:  180))
                .position(coordinate.drawPoint.scale(length))
        }
        .onTapGesture {
            action()
        }
    }
}

struct HexagonMenuCellView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleButtonView(text:"setting", imageName: "gearshape.fill", coordinate: TriangleCenterCoordinate(x: 1, y: 1), action: {}, length: 200 )
    }
}
