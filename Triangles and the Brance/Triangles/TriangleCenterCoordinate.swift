//
//  TriangleCenterCoordinate.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/25.
//

import Foundation
import SwiftUI

///座標、中心部分を使ってステージの中の位置を表す
struct TriangleCenterCoordinate:Hashable, StageCoordinate {
    var x: Int
    var y: Int
    let position: Position = .center
    ///ModelCoordinateの座標系から実際に描画する際の中心ポイントを返す
    var drawPoint:CGPoint{
        let X = CGFloat(x)
        let Y = CGFloat(y)

        let remainder = x % 2
        if remainder == 0{
            return CGPoint(x: (X/2 + Y/2), y: Y * sqrt(3)/2 + 1/(2*sqrt(3)))
        }else{
            //正三角形を180度回転したときに生じる中心地点のずれ
            let distance = 1 / sqrt(3)
            return CGPoint(x: (X/2 + Y/2), y: (distance + sqrt(3)/2 * Y))
        }
    }
    
    ///隣接する座標のSet
    var nextCoordinates: Set<TriangleCenterCoordinate> {
       let nextCoordinates: Set<TriangleCenterCoordinate>
       let remainder = self.x % 2
        if remainder == 0 {
            nextCoordinates = ([
               TriangleCenterCoordinate(x: self.x-1, y: self.y),
               TriangleCenterCoordinate(x: self.x+1, y: self.y-1),
               TriangleCenterCoordinate(x: self.x+1, y: self.y),])
        }else{
            nextCoordinates = ([
               TriangleCenterCoordinate(x: self.x-1, y: self.y),
               TriangleCenterCoordinate(x: self.x+1, y: self.y),
               TriangleCenterCoordinate(x: self.x-1, y: self.y+1),])
        }
        return nextCoordinates
    }
    ///三角形の向き
    var reversed: Bool {
        let remainder = x % 2
        if remainder == 0 {
            return true
        } else {
            return false
        }
    }
    
    //相対座標を指定する配列から現在の座標をもとにした座標の配列を返す
    func relative(coordinates: [[(x: Int, y: Int)]]) -> [[TriangleCenterCoordinate]] {
        coordinates.map { coor in
            coor.map {
                if reversed {
                  return  TriangleCenterCoordinate(x: self.x + $0.x, y: self.y + $0.y)
                } else {
                  return  TriangleCenterCoordinate(x: self.x - $0.x, y: self.y - $0.y)
                }
            }
        }
    }
}

