//
//  UserData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation
import Combine

//データクラスにアクセスするクラス
final class SaveData {
        
    private let dataClass: DataClass
    static let shared = SaveData()
    private init() {
        #if GameDesignTest
        dataClass = TestData()
        #else
        dataClass = UserData()
        #endif
    }
 
    func loadData<T:SaveDataName>(name: T)-> Int {
        return dataClass.loadData(name: name)
    }
    
    func saveData<T:SaveDataName>(name: T, value: Int) {
        dataClass.saveData(name: name, intValue: value)
    }
    
    func loadData<T:SaveDataName, U:Codable>(name: T,valueType: U.Type) -> Optional<U> {
        dataClass.loadData(name: name, valueType: valueType)
    }
    
    func saveData<T:SaveDataName, U:Codable>(name: T, value: U) {
        dataClass.saveData(name: name, value: value)
    }
}


final class UserData: DataClass {
    
    func loadData<T:SaveDataName>(name: T) -> Int {
        //データが存在しない場合は0が帰ってくるが、現状取り扱っているデータに関して初期値が0のためそのまま利用する
        UserDefaults.standard.integer(forKey: name.description)
    }
    func saveData<T:SaveDataName>(name: T,intValue: Int ) {
        UserDefaults.standard.set(intValue, forKey: name.description)
    }
    //任意のCodableな構造体のデータを読み込む
    func loadData<T:SaveDataName, U:Codable>(name: T,valueType: U.Type) -> Optional<U> {
        let data = UserDefaults.standard.data(forKey: name.description)
        guard let data = data else {
            return nil
        }
        do {
           let value = try JSONDecoder().decode(valueType.self, from: data)
            return value
        } catch {
            return nil
        }
    }
    func saveData<T:SaveDataName, U:Codable>(name: T, value: U) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: name.description)
        } catch {
            print(error)
            return
        }
    }
}

protocol DataClass {
    func saveData<T:SaveDataName>(name: T, intValue: Int)
    func loadData<T:SaveDataName>(name: T) -> Int
    func loadData<T:SaveDataName, U:Codable>(name: T,valueType: U.Type) -> Optional<U>
    func saveData<T:SaveDataName, U:Codable>(name: T, value: U)
}

protocol SaveDataName {
    var description: String { get }
}

extension SaveDataName {
    //データ保存用のString、名前の重複を避けるため、型名も同時に取得
    var description:String {
        String(describing: type(of: self)) + String(describing: self)
    }
}
