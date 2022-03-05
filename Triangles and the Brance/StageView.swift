//
//  StageView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct StageView: View {
    private typealias T = Triangle
    private let stageArrangement:[T]  = [
        T(X: 2, Y: 0, r: true),T(X: 3, Y: 0, r: true),T(X: 4, Y: 0, r: true),
        T(X: 1, Y: 1, r: true),T(X: 2, Y: 1, r: true),T(X: 3, Y: 1, r: true),T(X: 4, Y: 1, r: true),
        T(X: 0, Y: 2, r: true),T(X: 1, Y: 2, r: true),T(X: 2, Y: 2, r: true),T(X: 3, Y: 2, r: true),T(X: 4, Y: 2, r: true),
        T(X: -1, Y: 3, r: true),T(X: 0, Y: 3, r: true),T(X: 1, Y: 3, r: true),T(X: 2, Y: 3, r: true),T(X: 3, Y: 3, r: true),T(X: 4, Y: 3, r: true),
        T(X: -1, Y: 4, r: true),T(X: 0, Y: 4, r: true),T(X: 1, Y: 4, r: true),T(X: 2, Y: 4, r: true),T(X: 3, Y: 4, r: true),
        T(X: -1, Y: 5, r: true),T(X: 0, Y: 5, r: true),T(X: 1, Y: 5, r: true),T(X: 2, Y: 5, r: true),
        
        T(X: 2, Y: 0, r: false),T(X: 3, Y: 0, r: false),T(X: 4, Y: 0, r: false),T(X: 5, Y: 0, r: false),
        T(X: 1, Y: 1, r: false),T(X: 2, Y: 1, r: false),T(X: 3, Y: 1, r: false),T(X: 4, Y: 1, r: false),T(X: 5, Y: 1, r: false),
        T(X: 0, Y: 2, r: false),T(X: 1, Y: 2, r: false),T(X: 2, Y: 2, r: false),T(X: 3, Y: 2, r: false),T(X: 4, Y: 2, r: false),T(X: 5, Y: 2, r: false),
        T(X: 0, Y: 3, r: false),T(X: 1, Y: 3, r: false),T(X: 2, Y: 3, r: false),T(X: 3, Y: 3, r: false),T(X: 4, Y: 3, r: false),
        T(X: 0, Y: 4, r: false),T(X: 1, Y: 4, r: false),T(X: 2, Y: 4, r: false),T(X: 3, Y: 4, r: false),
        T(X: 0, Y: 5, r: false),T(X: 1, Y: 5, r: false),T(X: 2, Y: 5, r: false),
    ]
    var body: some View {
        GeometryReader{ geometory in
        ZStack{
            ForEach(stageArrangement){ item in
                NormalTriangle(triangle: item, length: geometory.size.width/7)
            }
        }
    }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}

struct stageArrangement{
    
}
