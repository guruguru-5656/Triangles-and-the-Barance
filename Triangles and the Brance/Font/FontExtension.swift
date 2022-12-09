//
//  FontExtension.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/09.
//

import Foundation
import SwiftUI

extension Font {
    static func smartFontUI(_ font: SmartFontUI, dynamic: Bool = false) -> Font {
        if dynamic {
            return  custom("SmartFontUI", size: font.size, relativeTo: font.style)
        }
        return custom("SmartFontUI", fixedSize: font.size)
    }
    
    static func smartFontUI(fixedSize: CGFloat) -> Font {
        custom("SmartFontUI", fixedSize: fixedSize)
    }
 
    enum SmartFontUI {
        case largeTitle, title, title2, body, caption
        var size: CGFloat {
            switch self {
            case .largeTitle:
                return 34.0
            case .title:
                return 28.0
            case .title2:
                return 22.0
            case .body:
                return 17.0
            case .caption:
                return 12.0
            }
        }
        var style: TextStyle {
            switch self {
            case .largeTitle:
                return .largeTitle
            case .title:
                return .title
            case .title2:
                return .title2
            case .body:
                return .body
            case .caption:
                return .caption
            }
        }
    }
}
