//
//  NormalTriangleView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

///トライアングルViewのモデルデータ
struct TriangleViewModel:Identifiable{
    
    init(x:Int,y:Int,isOn:Bool){
        modelCoordinate = ModelCoordinate(x: x, y: y)
        self.isOn = isOn
    }

    
    var modelCoordinate:ModelCoordinate
    var isOn:Bool
    //強参照を避けるため、weak varで宣言
    //ステージモデルの初期化時にTriangleViewModelのインスタンスの生成とdelegateの設定がされるため、
    weak var delegate:StageModel?
    
    ///消去するプロセスを呼ぶ
    ///自身の持つisOnプロパティがfalseだった場合は何もしない
    func deleteTriangles(){
        guard self.isOn == true else{ return }
        guard let delegate = delegate else {
            print("Error:デリゲートが設定されていません")
            return
        }
        DispatchQueue.global().async{
            delegate.deleteTriangles(coordinate: self.modelCoordinate,action:.normal)
        }
    }
    
    var action:ActionOfShape = .normal
    var id = UUID()
    
    var nextModelCoordinates:[(x:Int,y:Int)]{
        var nextCoordinates:[(x:Int,y:Int)] = []
        let remainder = modelCoordinate.x % 2
        if remainder == 0{
            nextCoordinates.append(contentsOf: [
                (modelCoordinate.x-1, modelCoordinate.y),
                (modelCoordinate.x+1, modelCoordinate.y-1),
                (modelCoordinate.x+1, modelCoordinate.y),])
        }else{
            nextCoordinates.append(contentsOf: [
                (modelCoordinate.x-1, modelCoordinate.y),
                (modelCoordinate.x+1, modelCoordinate.y),
                (modelCoordinate.x-1, modelCoordinate.y+1),])
        }
        return nextCoordinates
    }
    
     
    ///対応する頂点の座標系
    var vertexCoordinate:[TriVertexCoordinate]{
        let returnCoordinates:[TriVertexCoordinate]

        let remainder = modelCoordinate.x % 2
        if remainder == 0{
            returnCoordinates = [TriVertexCoordinate(x:modelCoordinate.x/2, y:modelCoordinate.y),
                          TriVertexCoordinate(x:modelCoordinate.x/2 + 1, y:modelCoordinate.y),
                          TriVertexCoordinate(x:modelCoordinate.x/2, y:modelCoordinate.y + 1)]
        }else{
            returnCoordinates = [TriVertexCoordinate(x:(modelCoordinate.x+1)/2, y:modelCoordinate.y),
                          TriVertexCoordinate(x:(modelCoordinate.x+1)/2 - 1, y:modelCoordinate.y + 1),
                          TriVertexCoordinate(x:(modelCoordinate.x+1)/2, y:modelCoordinate.y + 1)]
        }
        return returnCoordinates
    }
    ///頂点の座標を取得するメソッドバージョン
    static func getVertexCoordinate(x:Int,y:Int) -> [TriVertexCoordinate]{
        let coordinates:[TriVertexCoordinate]

        let remainder = x % 2
        if remainder == 0{
            coordinates = [TriVertexCoordinate(x:x/2, y:y),
                          TriVertexCoordinate(x:x/2 + 1, y:y),
                          TriVertexCoordinate(x:x/2, y:y + 1)]
        }else{
            coordinates = [TriVertexCoordinate(x:(x+1)/2, y:y),
                          TriVertexCoordinate(x:(x+1)/2 - 1, y:y + 1),
                          TriVertexCoordinate(x:(x+1)/2, y:y + 1)]
        }
        return coordinates
    }
}

///座標、中心部分を使ってステージの中の位置を表す
struct ModelCoordinate:Hashable{
    var x:Int
    var y:Int
}

protocol TriangleViewModelDelegate{
    typealias Coordinate = (x: Int,y: Int)
    func deleteTriangles(coordinate:ModelCoordinate,action:ActionOfShape)
}

enum ActionOfShape{
    case normal
}
