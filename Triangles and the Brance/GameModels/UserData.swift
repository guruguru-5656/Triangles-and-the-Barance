//
//  UserData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation
import Combine

//データクラスにアクセスするクラス
final class UserDataInterface {
        
    private let dataClass: DataClass
    static let shared = UserDataInterface()
    private init() {
        #if GameDesignTest
        dataClass = TestData()
        #else
        dataClass = UserData()
        #endif
    }
 
    func loadData<T:SaveDataValue>(type: T)-> Int {
        dataClass.loadData(type: type)
    }
    func saveData<T:SaveDataValue>(type: T, value: Int) {
        dataClass.saveData(type: type, value: value)
    }
}


final class UserData: DataClass {
    
    func loadData<T:SaveDataValue>(type: T) -> Int {
        //データが存在しない場合は0が帰ってくるが、現状取り扱っているデータに関して初期値が0のためそのまま利用する
        UserDefaults.standard.integer(forKey: type.description)
    }
    func saveData<T:SaveDataValue>(type: T,value: Int ) {
        UserDefaults.standard.set(value, forKey: type.description)
    }
    
}

protocol DataClass {
    func saveData<T:SaveDataValue>(type: T, value: Int)
    func loadData<T:SaveDataValue>(type: T) -> Int
}

protocol SaveDataValue {
    associatedtype Data: Codable
    var description: String { get }
    var defaultValue:Data { get }
    var testValue:Data { get }
}

extension SaveDataValue  {
    //データ保存用の値、名前の重複を避けるため、型名も同時に取得
    var description:String {
        String(describing: type(of: self)) + String(describing: self)
    }
}
