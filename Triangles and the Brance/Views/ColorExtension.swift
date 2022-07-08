//
//  ColorExtension.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/05.
//

import SwiftUI

extension Color {
    static let allmostClear = Color( white: 1, opacity: 0.01)
    static let backgroundLightGray = Color(white: 0.85)
    static let ultraLightGray = Color(white: 0.95)
    static let lightGray = Color(white: 0.9)
    
    static let lightRed = Color(red: 255/255, green: 165/255, blue: 165/255)
    static let lightOrenge = Color(red: 255/255, green: 211/255, blue: 165/255)
    static let lightYellow = Color(red: 240/255, green: 240/255, blue: 155/255)
    static let lightYellowGreen = Color(red: 197/255, green: 240/255, blue: 155/255)
    static let lightGreen = Color(red: 156/255, green: 240/255, blue: 155/255)
    static let lightGreenBlue = Color(red: 155/255, green: 240/255, blue: 198/255)
    static let lightWaterBlue = Color(red: 156/255, green: 240/255, blue: 240/255)
    static let lightWhiteBlue = Color(red: 165/255, green: 211/255, blue: 255/255)
    static let lightBluePurple = Color(red: 165/255, green: 165/255, blue: 255/255)
    static let lightPurple = Color(red: 210/255, green: 165/255, blue: 255/255)
    static let lightFujiPurple = Color(red: 255/255, green: 165/255, blue: 255/255)
    static let lightPinkPurple = Color(red: 255/255, green: 165/255, blue: 211/255)
        
    static let heavyRed = Color(red: 160/255, green: 84/255, blue: 84/255)
    static let heavyOrenge = Color(red: 160/255, green: 123/255, blue: 84/255)
    static let heavyYellow = Color(red: 160/255, green: 160/255, blue: 84/255)
    static let heavyYellowGreen = Color(red: 122/255, green: 160/255, blue: 84/255)
    static let heavyGreen = Color(red: 84/255, green: 160/255, blue: 85/255)
    static let heavyGreenBlue = Color(red: 84/255, green: 160/255, blue: 122/255)
    static let heavyWaterBlue = Color(red: 84/255, green: 160/255, blue: 159/255)
    static let heavyWhiteBlue = Color(red: 84/255, green: 123/255, blue: 160/255)
    static let heavyBluePurple = Color(red: 84/255, green: 85/255, blue: 160/255)
    static let heavyPurple = Color(red: 122/255, green: 84/255, blue: 160/255)
    static let heavyFujiPurple = Color(red: 160/255, green: 84/255, blue: 160/255)
    static let heavyPinkPurple = Color(red: 160/255, green: 84/255, blue: 122/255)
}

struct StageViewColor_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}

///カラーをループする構造にした列挙体。イニシャライザで初期値が設定され、nextColorメソッドを呼ぶたびに次のcaseが表示される
enum MyColor: Int {
    case red = 0
    case orenge,yellow,yellowGreen,green,greenBlue,
         waterBlue,whiteBlue,bluePurple,purple,fujiPurple,
         pinkPurple
    init(){
        self = .red
    }
    ///次のカラーに移る
    mutating func nextColor(){
        switch self{
        case .pinkPurple:
            return self = MyColor.red
        default:
            return self = MyColor.init(rawValue: self.rawValue+1)!
        }
    }
    
    var previousColor: MyColor {
        switch self {
        case .red:
            return .pinkPurple
        default:
            return MyColor.init(rawValue: self.rawValue-1)!
        }
    }
    
    var light: Color {
        switch self {
        case .red:
            return .lightRed
        case .orenge:
            return .lightOrenge
        case .yellow:
            return .lightYellow
        case .yellowGreen:
            return .lightYellowGreen
        case .green:
            return .lightGreen
        case .greenBlue:
            return .lightGreenBlue
        case .waterBlue:
            return .lightWaterBlue
        case .whiteBlue:
            return .lightWhiteBlue
        case .bluePurple:
            return .lightBluePurple
        case .purple:
            return .lightPurple
        case .fujiPurple:
            return .lightFujiPurple
        case .pinkPurple:
            return .lightPinkPurple
        }
    }
    var heavy: Color {
        switch self {
        case .red:
            return .heavyRed
        case .orenge:
            return .heavyOrenge
        case .yellow:
            return .heavyYellow
        case .yellowGreen:
            return .heavyYellowGreen
        case .green:
            return .heavyGreen
        case .greenBlue:
            return .heavyGreenBlue
        case .waterBlue:
            return .heavyWaterBlue
        case .whiteBlue:
            return .heavyWhiteBlue
        case .bluePurple:
            return .heavyBluePurple
        case .purple:
            return .heavyPurple
        case .fujiPurple:
            return .heavyFujiPurple
        case .pinkPurple:
            return .heavyPinkPurple
        }
    }
}

