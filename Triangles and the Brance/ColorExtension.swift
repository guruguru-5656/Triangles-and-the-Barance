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
class StageStatus:ObservableObject{
    @Published var currentColor = MyColor.lightRed
    //インスタンスを生成するとデフォルト値がMyColorにセットされる
    //nextメソッドを実行すると、次のカラーを取得し、現在のカラーを更新する
    func next(){
        var nextColor:MyColor
        switch currentColor{
        case .lightPink:
            nextColor = MyColor.lightRed
        default:
            nextColor = MyColor.init(rawValue: currentColor.rawValue+1)!
        }
        currentColor = nextColor
    }
    
    enum MyColor:Int{
        case lightRed = 0
        case lightOrenge,lightYellow,lightYellowGreen,lightGreen,lightGreenBlue,
             lightWaterBlue,lightWhiteBlue,lightBluePurple,lightPurple,lightFujiPurple,
             lightPinkPurple,lightPink
        
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
}
