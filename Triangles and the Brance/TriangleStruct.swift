//
//  TriangleModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import Foundation
import SwiftUI

struct Triangle:Identifiable{
    var length:Double
    let X:Int
    let Y:Int
    let reversed: Bool
    var id = UUID()
    let color:Color
    //NormalTriangle構造体の方で実装することにしたため、コメントアウト
//    var coordinates:[CGPoint]{
//        let coordinates:[CGPoint]
//        if reversed{
//            coordinates = [CGPoint(x: (Double(X)+Double(Y)/2) * length,
//                                   y: Double(X) * sqrt(3)/2 * length),
//                           CGPoint(x: (Double(X)+Double(Y+1)/2) * length,
//                                   y: Double(X) * sqrt(3)/2 * length),
//                           CGPoint(x: (Double(X-1)+Double(Y+1)/2) * length,
//                                   y: Double(X-1) * sqrt(3)/2 * length)]
//        }
//        else{
//            coordinates = [CGPoint(x: (Double(X)+Double(Y)/2) * length,
//                                   y: Double(X) * sqrt(3)/2 * length),
//                           CGPoint(x: (Double(X+1)+Double(Y)/2) * length,
//                                   y: Double(X+1) * sqrt(3)/2 * length),
//                           CGPoint(x: (Double(X)+Double(Y+1)/2) * length,
//                                   y: Double(X) * sqrt(3)/2 * length)]
//        }
//        return coordinates
//    }
}

struct NormalTriangle:TriangleProtocol {
    var triangle:Triangle
}

protocol TriangleProtocol:Shape{
    var triangle: Triangle{ get set }
    func path(in rect: CGRect) -> Path
}
extension TriangleProtocol{
    func path(in rect: CGRect) -> Path {
        let length = Double(rect.width)
        let coordinates:[CGPoint]
        //三角形の向きによって計算式を変更
        if triangle.reversed{
            coordinates = [CGPoint(x: (Double(triangle.X)+Double(triangle.Y)/2) * length,
                                   y: Double(triangle.X) * sqrt(3)/2 * length),
                           CGPoint(x: (Double(triangle.X)+Double(triangle.Y+1)/2) * length,
                                   y: Double(triangle.X) * sqrt(3)/2 * length),
                           CGPoint(x: (Double(triangle.X-1)+Double(triangle.Y+1)/2) * length,
                                   y: Double(triangle.X-1) * sqrt(3)/2 * length)]
        }else{
            coordinates = [CGPoint(x: (Double(triangle.X)+Double(triangle.Y)/2) * length,
                                   y: Double(triangle.X) * sqrt(3)/2 * length),
                           CGPoint(x: (Double(triangle.X+1)+Double(triangle.Y)/2) * length,
                                   y: Double(triangle.X+1) * sqrt(3)/2 * length),
                           CGPoint(x: (Double(triangle.X)+Double(triangle.Y+1)/2) * length,
                                   y: Double(triangle.X) * sqrt(3)/2 * length)]
        }
        
        return Path{ path in
            path.addLines(coordinates)
        }
    }
}
