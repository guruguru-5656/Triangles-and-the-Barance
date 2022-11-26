//
//  Calculation.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/24.
//

import Foundation

enum Calculation {
    
    static func individualScore(_ count: Int) -> Int {
        return Int((1 + 0.5 * Double(count)) * Double(count)) 
    }
}
