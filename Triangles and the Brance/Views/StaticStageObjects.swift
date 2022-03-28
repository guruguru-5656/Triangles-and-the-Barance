//
//  stageBackGround.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/26.
//

import Foundation

struct StaticStageObjects {
    init(){
        setStageLines()
    }
    ///線を引くビューのセットアップ
    private mutating func setStageLines(){
        let lines = lineArrangement.map {
            TriLine(start: TriVertexCoordinate(x: $0.start.x, y: $0.start.y),
                    end: TriVertexCoordinate(x: $0.end.x, y: $0.end.y))
        }
        stageLines.append(contentsOf: lines)
    }
    ///ステージに引く線の配置
    private let lineArrangement:[(start:(x:Int,y:Int),end:(x:Int,y:Int))] = [
        ((2,0),(5,0)),((1,1),(5,1)), ((0,2),(5,2)), ((-1,3),(5,3)), ((-1,4),(4,4)), ((-1,5),(3,5)),((-1,6),(2,6)),
        ((-1,3),(-1,6)),((0,2),(0,6)), ((1,1),(1,6)), ((2,0),(2,6)), ((3,0),(3,5)), ((4,0),(4,4)),((5,0),(5,3)),
        ((2,0),(-1,3)),((3,0),(-1,4)), ((4,0),(-1,5)), ((5,0),(-1,6)), ((5,1),(0,6)), ((5,2),(1,6)),((5,3),(2,6))
    ]
    var stageLines:[TriLine] = []
    //ステージの背景の六角形
    static let hexagon:[TriVertexCoordinate] = [
        TriVertexCoordinate(x: 2, y: 0), TriVertexCoordinate(x: 5, y: 0),
        TriVertexCoordinate(x: 5, y: 3),TriVertexCoordinate(x: 2, y: 6),
        TriVertexCoordinate(x: -1, y: 6),TriVertexCoordinate(x: -1, y: 3),
        TriVertexCoordinate(x: 2, y: 0)
    ]
    //ビューの再生成時にidが変わらないようにあらかじめ生成
    static let normalActionItem = ActionItemModel(action: .normal, status: .onAppear)
    
}
