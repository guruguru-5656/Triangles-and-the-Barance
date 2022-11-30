//
//  UserData.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/08/13.
//

import Foundation
import Combine

//データクラスを切り替えるためのクラス
final class SaveData: DataClass {
   
    
        
    private let dataClass: DataClass
    static let shared = SaveData()
    
    private init() {
        #if TEST
        dataClass = TestData()
        #else
        dataClass = UserData()
        #endif
    }
 
    func loadData<T: SaveDataName>(name: T)-> Int {
        return dataClass.loadData(name: name)
    }
    
    func saveData<T: SaveDataName>(name: T, intValue: Int) {
        dataClass.saveData(name: name, intValue: intValue)
    }
    
    func loadData<T: Codable>(type: T.Type) -> Optional<T> {
        dataClass.loadData(type: type)
    }
    
    func saveData<T: Codable>(value: T) {
        dataClass.saveData(value: value)
    }
}


final class UserData: DataClass {
    
    func saveData<T:SaveDataName>(name: T,intValue: Int ) {
        UserDefaults.standard.set(intValue, forKey: name.description)
    }
    
    func loadData<T:SaveDataName>(name: T) -> Int {
        //データが存在しない場合は0が帰ってくるが、現状取り扱っているデータに関して初期値が0のためそのまま利用する
        UserDefaults.standard.integer(forKey: name.description)
    }
    
    //structをdata型に変換して保存する
    func saveData<T: Codable>(value: T) {
        do {
            let data = try JSONEncoder().encode(value)
            let key = String(describing: T.self)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
            return
        }
    }
    
    func loadData<T: Codable>(type: T.Type) -> Optional<T>{
        let key = String(describing: T.self)
        let data = UserDefaults.standard.data(forKey: key)
        guard let data = data else {
            return nil
        }
        do {
           let value = try JSONDecoder().decode(type, from: data)
            return value
        } catch {
            return nil
        }
    }
}

