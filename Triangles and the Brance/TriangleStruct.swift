//
//  TriangleModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import Foundation
import SwiftUI

struct Triangle:Identifiable{
    let X:Int
    let Y:Int
    let r: Bool
    var id = UUID()
    let color:Color = .lightRed
}

struct NormalTriangle:TriangleProtocol {
    var offset: CGFloat
    var triangle:Triangle
    var length:CGFloat
}

protocol TriangleProtocol:View{
    var triangle: Triangle{ get set }
    var coordinates:[CGPoint]{ get }
    var length:CGFloat{ get set }
    var offset:CGFloat{ get set }
}
extension TriangleProtocol{
    var coordinates:[CGPoint]{
        let coordinates:[CGPoint]
        let offsetA = offset * sqrt(3)/2 //offset * cos(30[deg])
        let x = CGFloat(triangle.X)
        let y = CGFloat(triangle.Y)
        let lengthY = length * sqrt(3)/2
        //三角形の向きによって計算式を変更
        if triangle.r{
            coordinates = [CGPoint(x: (x + y/2) * length + offsetA,
                                   y: y * lengthY + offset/2),
                           CGPoint(x: ((x+1) + y/2 ) * length - offsetA,
                                   y: y * lengthY + offset/2),
                           CGPoint(x: (x + (y+1)/2) * length,
                                   y: (y+1) * lengthY - offset),
                           CGPoint(x: (x + y/2) * length + offsetA,
                                   y: y * lengthY + offset/2)]
        }else{
            coordinates = [CGPoint(x: (x + y/2) * length,
                                   y: y * lengthY + offset),
                           CGPoint(x: (x + (y+1)/2) * length - offsetA,
                                   y: (y+1) * lengthY - offset/2),
                           CGPoint(x: ((x-1) + (y+1)/2) * length + offsetA,
                                   y: (y+1) * lengthY - offset/2),
                           CGPoint(x: (x + y/2) * length,
                                   y: y * lengthY + offset),]
        }
        return coordinates
    }
    
    var body:some View{
        
        Path{ path in
            path.addLines(coordinates)
        }
        .fill(triangle.color)
    }
}
