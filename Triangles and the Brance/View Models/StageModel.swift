//
//  StageModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/06.
//

import SwiftUI


class StageModel:ObservableObject{
    
    @Published var currentColor = MyColor()
    @Published var triangles: [TriangleViewModel] = []
    @Published var actionItems:[ActionItemModel] = []
    @Published var selectedActionItem:ActionItemModel?
    
    ///外側の配列がY軸、内側の配列がX軸を表す
    private var triangleArrengement: [[Int]] = [
        [Int](3...9),
        [Int](1...9),
        [Int](-1...9),
        [Int](-2...8),
        [Int](-2...6),
        [Int](-2...4)
    ]
    
    ///ステージに引く線の配置
    private let lineArrangement:[(start:(x:Int,y:Int),end:(x:Int,y:Int))] = [
        ((2,0),(5,0)),((1,1),(5,1)), ((0,2),(5,2)), ((-1,3),(5,3)), ((-1,4),(4,4)), ((-1,5),(3,5)),((-1,6),(2,6)),
        ((-1,3),(-1,6)),((0,2),(0,6)), ((1,1),(1,6)), ((2,0),(2,6)), ((3,0),(3,5)), ((4,0),(4,4)),((5,0),(5,3)),
        ((2,0),(-1,3)),((3,0),(-1,4)), ((4,0),(-1,5)), ((5,0),(-1,6)), ((5,1),(0,6)), ((5,2),(1,6)),((5,3),(2,6))
    ]
    var stageLines:[TriLine] = []
    //ステージの背景の六角形
    let backGroundHexagon:[TriVertexCoordinate] = [
        TriVertexCoordinate(x: 2, y: 0), TriVertexCoordinate(x: 5, y: 0),
        TriVertexCoordinate(x: 5, y: 3),TriVertexCoordinate(x: 2, y: 6),
        TriVertexCoordinate(x: -1, y: 6),TriVertexCoordinate(x: -1, y: 3),
        TriVertexCoordinate(x: 2, y: 0)
    ]
    
    //ステージの生成時の確率をまとめたクラス
    private var probabilityOfLayout = ProbabilityOfStageLayout()
    
    //Triangleを消した数のカウント、クリアチェックに利用
    var deleteTriangleCounter:Int = 0
    
    init(){
        //初期化時にステージの構造を生成
        setStageTriangles()
        setStageLines()
        setStageActionItems()
        deleteTriangleCounter = 0
    }
    
    //ステージの構造生成
    ///三角形のビューのセットアップ
    func setStageTriangles(){
        for (triangleY, arrangement) in triangleArrengement.enumerated(){
            for triangleX in arrangement{
                
                let random:Double = Double.random(in:1...100)
                if random <= probabilityOfLayout.ofTriangles{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOn, action: nil )
                    triangles.append(triangleModel)
                }else{
                    let triangleModel = TriangleViewModel(x: triangleX, y: triangleY, status: .isOff, action: nil )
                    triangles.append(triangleModel)
                }
            }
        }
    }
    ///線を引くビューのセットアップ
    func setStageLines(){
        let lines = lineArrangement.map{
            TriLine(start: TriVertexCoordinate(x: $0.start.x, y: $0.start.y),
                    end: TriVertexCoordinate(x: $0.end.x, y: $0.end.y))
        }
        stageLines.append(contentsOf: lines)
    }
    
    ///ステージにItemの描画をセットする
    func setStageActionItems(){
        //TODO: 前のステージで持っていたアイテムを引き継ぐ
        actionItems.append(contentsOf: [ActionItemModel(action: .triforce)])
    }
    
    ///Triangleのステータスを参照し、アクションを実行するか判断する
    ///statusがisOnだった場合はdeleteTrianglesを呼び出す
    func trianglesTapAction(index:Int) {
        
        //ステータスがisOnの場合は消去のプロセスに入る
        if triangles[index].status == .isOn{
            let coordinate = triangles[index].coordinate
            do{
                //ステージ内にある情報を渡して、アクションを呼びだし、スコアの情報を受け取る
                let action = ChangeTriangleStatusAction(item: selectedActionItem, stageItems: actionItems, triangles: triangles)
                print(coordinate)
                try action.deleteTriangles(coordinate: coordinate,action:triangles[index].action){ (onOrOff:OnOrOff,index:Int,counter) -> Void in
                    switch onOrOff {
                    case .turnOn:
                        self.turnOnTriangles(index: index, count: counter)
                    case .turnOff:
                        self.turnOffTriangles(index: index, count: counter)
                    }
                    
                }
//                { [weak self] score in
//                    if score.count >= 8{
//                        self?.actionItems.append(ActionItemModel(action: .triforce))
//                    }
//                    //TODO: スコアの計算を行う
//                    self?.deleteTriangleCounter += score.count
//                }
            }catch{
                print("ERROR:\(error)")
            }
            
        }else{
            //アイテムが入っていた場合はtrianglesにセットする
            if let selectedItem = selectedActionItem{
                triangles[index].action = selectedItem.action
                guard let itemIndex = actionItems.firstIndex(where: { $0.id == selectedItem.id})
                else{
                    print("インデックスエラー")
                    return
                }
                //アイテムの更新
                actionItems.remove(at: itemIndex)
                selectedActionItem = nil
            }
            triangles[index].status = .isOn
        }
    }
    ///指定されたインデックス番号のTriangleのステータスをOffにしてビューに反映させる
    ///順番に描画が更新されるように時間をずらしながら実行
    func turnOffTriangles(index:Int,count:Int){

            self.triangles[index].status = .isDisappearing
        
            
        let timeCount = DispatchTime.now() + DispatchTimeInterval.milliseconds( count * 300)
        DispatchQueue.main.asyncAfter(deadline: timeCount){ [weak self] in
            self?.triangles[index].status = .isOff
            self?.triangles[index].action = nil
        }
            
        
    }
    ///指定されたインデックス番号のTriangleのステータスをOnにしてビューに反映させる
    ///順番に描画が更新されるように時間をずらしながら実行
    func turnOnTriangles(index:Int,count:Int){
        self.triangles[index].status = .onAppear
        
        let timeCount = DispatchTime.now() + DispatchTimeInterval.milliseconds( count * 300)
        DispatchQueue.main.asyncAfter(deadline: timeCount){ [weak self] in
            self?.triangles[index].status = .isOn
        }
    }
}

enum StageError:Error{
    case isNotExist
    case triangleIndexError
}
