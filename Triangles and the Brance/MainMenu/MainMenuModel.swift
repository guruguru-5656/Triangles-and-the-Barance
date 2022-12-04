//
//  MainMenuModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/02.
//

import Foundation

struct MainMenuCellModel: Identifiable {
    let menu: MainMenus
    let action: () -> Void
    
    var text: String {
        switch menu {
        case .tutrial:
            return "tutrial"
        case .game:
           return  "START"
        case .upgrade:
           return "upgrade"
        case .highScore:
            return "score"
        case .setting:
            return "settings"
        }
    }
    
    var imageName: String {
        switch menu {
        case .tutrial:
            return "book"
        case .game:
            return "play"
        case .upgrade:
            return "arrowtriangle.up"
        case .highScore:
            return "list.star"
        case .setting:
            return "gearshape.fill"
        }
    }
    
    var coordinate: TriangleCenterCoordinate {
        switch menu {
        case .tutrial:
            return .init(x: 1, y: 0)
        case .game:
            return .init(x: 2, y: 0)
        case .upgrade:
            return .init(x: 3, y: 0)
        case .highScore:
            return .init(x: 0, y: 1)
        case .setting:
            return .init(x: 2, y: 1)
        }
    }
   
    let id = UUID()
}

enum MainMenus: CaseIterable {
    case tutrial
    case game
    case upgrade
    case highScore
    case setting
}
