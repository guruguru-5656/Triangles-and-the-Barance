//
//  TriangleModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import Foundation
import SwiftUI
//            .animation(.easeOut,value: stage.stageTriangles[indexOfStage].isOn ? 3 : -8)
//            .foregroundColor(stage.currentColor.color)
//            .onTapGesture {
//                    stage.delete(coordinate: coordinate)
//            }
//            .opacity(stage.stageTriangles[indexOfStage].isOn ? 1 :0)
//            .animation(.easeOut(duration: 1),
//                       value: stage.stageTriangles[indexOfStage].isOn ? 1 :0)
//    }


struct TriangleView:View{
//    @ObservedObject var stage:StageModel
    var triangle:TriangleModel
    var scale:CGFloat
    var offset: CGFloat
    
    var coordinates:[TriCoordinate]{
        let returnCoordinates:[TriCoordinate]
        let coordinate = triangle.modelCoordinates
        let remainder = triangle.modelCoordinates.x % 2
        if remainder == 0{
            returnCoordinates = [TriCoordinate(x:coordinate.x/2, y:coordinate.y),
                          TriCoordinate(x:coordinate.x/2 + 1, y:coordinate.y),
                          TriCoordinate(x:coordinate.x/2, y:coordinate.y + 1)]
        }else{
            returnCoordinates = [TriCoordinate(x:(coordinate.x+1)/2, y:coordinate.y),
                          TriCoordinate(x:(coordinate.x+1)/2 - 1, y:coordinate.y + 1),
                          TriCoordinate(x:(coordinate.x+1)/2, y:coordinate.y + 1)]
        }
        return returnCoordinates
    }
    
    var body:some View{
        DrawTriShape(in: coordinates,  scale: scale, offset:1)
    }
}


struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView(triangle: TriangleModel(x: 7, y: 3, isOn: true), scale: 50, offset: 1.0)
            .foregroundColor(.red)
    }
}

