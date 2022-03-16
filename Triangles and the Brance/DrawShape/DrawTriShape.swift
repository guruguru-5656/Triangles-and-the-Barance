//
//  DrawTriShape.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/11.
//

import SwiftUI

///TriCoordinate座標系から頂点を設定
///scaleに親Viewのサイズから設定した拡大率を入力
///scaleを変更すると拡大率とともに位置がずれる（この構造体は親ビューの原点座標を基準として描画を行う）ため個別の拡大率offsetを設定
struct DrawTriShape:Shape{
    ///頂点の座標系からインスタンスを生成する
    init(in coordinate:[TriVertexCoordinate],scale:CGFloat ,offset: CGFloat){
        self.coordinates = coordinate
        self.scale = scale
        self.offset = offset
        //描画用の頂点座標の設定
        self.vertexPoints = getVertexPoint(coordinates: self.coordinates)
        //中心点の設定
        self.centerPoint = getCenterPoint(vertex: vertexPoints)
        //補正値を計算し、描画用の値をセットする
        self.collectionValue = makeTransform(center: centerPoint, scale: self.offset)
        self.originalPath = Path{ path in
            path.addLines(vertexPoints)
            path.addLine(to: vertexPoints[0])
        }
        setDrawPath()
    }
    
    ///中央の座標系からインスタンスを生成する
    init(in coordinate:(x:Int,y:Int),scale:CGFloat ,offset: CGFloat){
        self.coordinates = TriangleViewModel.getVertexCoordinate(x: coordinate.x, y: coordinate.y)
        self.scale = scale
        self.offset = offset
        //描画用の頂点座標の設定
        self.vertexPoints = getVertexPoint(coordinates: self.coordinates)
        //中心点の設定
        self.centerPoint = getCenterPoint(vertex: vertexPoints)
        //補正値を計算し、描画用の値をセットする
        self.collectionValue = makeTransform(center: centerPoint, scale: self.offset)
        self.originalPath = Path{ path in
            path.addLines(vertexPoints)
            path.addLine(to: vertexPoints[0])
        }
        setDrawPath()
    }
    
    
    //初期値
    let coordinates:[TriVertexCoordinate]
    let scale:CGFloat
    var offset: CGFloat
    //頂点のポイントと中央のポイント
    private var vertexPoints:[CGPoint] = []
    private var centerPoint:CGPoint!
    //補正をかけないPathと補正後のPath
    private var originalPath:Path!
    private var transformedPath:Path!
    //拡大用の補正値
    private var collectionValue:CGAffineTransform?
    
    //値の変更を感知し、アニメーション効果を作る
    var animatableData:CGFloat{
        get{ offset }
        set{
            offset = newValue
            collectionValue = makeTransform(center: centerPoint, scale: offset)
            setDrawPath()
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.addPath(transformedPath)
        }
    }
    
    private func getVertexPoint(coordinates:[TriVertexCoordinate]) -> [CGPoint]{
        let vertex = coordinates.map{
            CGPoint(x:$0.getDrowPoint().x * scale ,y:$0.getDrowPoint().y * scale)
        }
        return vertex
    }
    ///中心点を設定する
    private func getCenterPoint(vertex:[CGPoint]) -> CGPoint{
        let coordinateX = vertex.map{$0.x}
        let coordinateY = vertex.map{$0.y}
        let avarageX = coordinateX.reduce(0){ $0 + $1 } / CGFloat(coordinateX.count)
        let avarageY = coordinateY.reduce(0){ $0 + $1 } / CGFloat(coordinateY.count)
        return CGPoint(x:avarageX,y:avarageY)
    }
    
    ///アフィン変換の補正値の生成
    ///一度中心点を原点に移動して倍率を変更した後に戻す
    private func makeTransform(center:CGPoint,scale:CGFloat) -> CGAffineTransform?{
        //倍率が0の場合は処理を行う必要がないため、nilを返す
        guard offset != 1 else{ return nil }
        var transform = CGAffineTransform(translationX: -center.x, y: -center.y)
        transform = transform.concatenating(CGAffineTransform(scaleX: scale, y: scale))
        transform = transform.concatenating(CGAffineTransform(translationX: center.x, y: center.y))
        return transform
    }
    
    private mutating func setDrawPath(){
        if let transform = collectionValue{
            transformedPath = Path{ path in
                path.addPath(originalPath, transform: transform)
            }
        }else{
            transformedPath = originalPath
        }
    }
}





struct DrawTriLine:Shape{
    init(line:TriLine,scale:CGFloat){
        startCoordinate = line.start
        endCoordinate = line.end
        self.scale = scale
    }
    init(start:TriVertexCoordinate, end:TriVertexCoordinate,scale:CGFloat){
        self.startCoordinate = start
        self.endCoordinate = end
        self.scale = scale
    }
    
    let startCoordinate:TriVertexCoordinate
    let endCoordinate:TriVertexCoordinate
    let scale:CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: startCoordinate.getDrowPoint().x * scale, y: startCoordinate.getDrowPoint().y * scale))
        path.addLine(to: CGPoint(x: endCoordinate.getDrowPoint().x * scale, y: endCoordinate.getDrowPoint().y * scale))
        return path
    }
}
