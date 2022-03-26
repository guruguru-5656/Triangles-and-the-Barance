//
//  ProbabilityOfStageLayout.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/14.
//

import Foundation

class StageLevelManeger{
    init(level: Int){
        self.probabilityOfTriangleIsOn = StageLevelManeger.baseProbabilityOfTriangleIsOn
        - Double(level) * 2
        self.probabilityOfTriangleHaveAction = StageLevelManeger.baseProbabilityOfTriangleHaveAction +
        Double(level) * 2
        self.targetNumberOfDeleteTriangle = 20 + level
    }
    var probabilityOfTriangleIsOn:Double
    var minimamNumberOfTriangleIsOn:Int = 20
    var probabilityOfTriangleHaveAction:Double
    var targetNumberOfDeleteTriangle:Int
    
    static let baseProbabilityOfTriangleIsOn:Double = 40
    static let baseProbabilityOfTriangleHaveAction:Double = 0
}

