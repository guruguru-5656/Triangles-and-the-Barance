//
//  ViewEnvironment.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/24.
//

import Foundation
import SwiftUI

class ViewEnvironment: ObservableObject{
    @Published var currentColor = MyColor()
    
    //初期値をiPhone 8の画面サイズで設定、ContentViewのonAppearの時に再読み込み
    @Published var screenBounds = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0)
    
    func resetGame() {
        currentColor = MyColor()
    }
    
    func stageClear() {
        currentColor.nextColor()
    }
}
