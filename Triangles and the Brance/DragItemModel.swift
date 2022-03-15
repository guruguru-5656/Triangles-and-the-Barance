//
//  DragItemModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import Foundation

struct DragItemModel:Identifiable{
    init(type:DragItemStrings,isRotated:Bool){
        let id = UUID()
        self.id = id
        self.type = type.rawValue
        self.isRotated = isRotated
    }
    
    var isRotated:Bool
    let type: NSString
    let id:UUID
    
}
enum DragItemStrings:NSString{
    case fillOneTriangle = "/One"
    
}
