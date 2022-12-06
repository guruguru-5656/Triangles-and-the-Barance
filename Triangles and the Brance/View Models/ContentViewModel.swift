//
//  ContentViewModel.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/20.
//

import Foundation

class ContentViewModel:ObservableObject{
    init(){
        stage = StageModel()
    }
    @Published var stage:StageModel
    
    func resetStage(){
        stage = StageModel()
    }
}
