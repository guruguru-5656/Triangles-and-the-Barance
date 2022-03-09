//
//  ColorExtension.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/05.
//

import SwiftUI

extension Color{
    static let lightGray = Color(white: 0.95)
    static let lightRed = Color(red: 255/255, green: 195/255, blue: 195/255)
    static let lightOrenge = Color(red: 255/255, green: 226/255, blue: 195/255)
    static let lightYellow = Color(red: 255/255, green: 255/255, blue: 195/255)
    static let lightYellowGreen = Color(red: 225/255, green: 255/255, blue: 195/255)
    static let lightGreen = Color(red: 195/255, green: 255/255, blue: 195/255)
    static let lightGreenBlue = Color(red: 195/255, green: 255/255, blue: 226/255)
    static let lightWaterBlue = Color(red: 195/255, green: 255/255, blue: 255/255)
    static let lightWhiteBlue = Color(red: 195/255, green: 226/255, blue: 255/255)
    static let lightBluePurple = Color(red: 195/255, green: 195/255, blue: 255/255)
    static let lightPurple = Color(red: 226/255, green: 195/255, blue: 255/255)
    static let lightFujiPurple = Color(red: 225/255, green: 195/255, blue: 255/255)
    static let lightPinkPurple = Color(red: 255/255, green: 195/255, blue: 255/255)
    static let lightPink = Color(red: 255/255, green: 195/255, blue: 226/255)
}


///カラーをループする構造にした列挙体。イニシャライザで初期値が設定され、nextColorメソッドを呼ぶたびに次のcaseが表示される
enum MyColor:Int{
    case lightRed = 0
    case lightOrenge,lightYellow,lightYellowGreen,lightGreen,lightGreenBlue,
         lightWaterBlue,lightWhiteBlue,lightBluePurple,lightPurple,lightFujiPurple,
         lightPinkPurple,lightPink
    init(){
        self = .lightPink
    }
    ///次のカラーに移る
    mutating func nextColor(){
        switch self{
        case .lightPink:
            return self = MyColor.lightRed
        default:
            return self = MyColor.init(rawValue: self.rawValue+1)!
        }
    }
    var color:Color{
        switch self{
        case .lightRed:
            return Color.lightRed
        case .lightOrenge:
            return Color.lightOrenge
        case .lightYellow:
            return Color.lightYellow
        case .lightYellowGreen:
            return Color.lightYellowGreen
        case .lightGreen:
            return Color.lightGreen
        case .lightGreenBlue:
            return Color.lightGreenBlue
        case .lightWaterBlue:
            return Color.lightWaterBlue
        case .lightWhiteBlue:
            return Color.lightWhiteBlue
        case .lightBluePurple:
            return Color.lightBluePurple
        case .lightPurple:
            return Color.lightPurple
        case .lightFujiPurple:
            return Color.lightFujiPurple
        case .lightPinkPurple:
            return Color.lightPinkPurple
        case .lightPink:
            return Color.lightPink
        }
    }
    
    
}
