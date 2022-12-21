//
//  DataProtocols.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/29.
//

import Foundation

protocol DataClass {
    func saveData<T: SaveDataName>(name: T, intValue: Int)
    func removeData<T:SaveDataName>(name: T)
    func loadData<T: SaveDataName>(name: T) -> Int
    func saveData<T: Codable>(value: T)
    func removeData<T: Codable>(value: T.Type)
    func loadData<T: Codable>(type: T.Type) -> Optional<T>
}

protocol SaveDataName {
    var description: String { get }
}

extension SaveDataName {
    //データ保存用のString、名前の重複を避けるため、型名も同時に取得
    var description: String {
        String(describing: type(of: self)) + String(describing: self)
    }
}

//データ保存用の名前
//バージョンアップにより削除
//enum StageState: SaveDataName {
//    case stage
//}
