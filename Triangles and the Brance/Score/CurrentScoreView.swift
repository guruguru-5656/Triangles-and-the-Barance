//
//  CurrentScoreView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/24.
//

import SwiftUI

struct CurrentScoreView: View {
    @EnvironmentObject private var gameModel: GameModel
    var body: some View {
        Text(String(gameModel.stageStatus.score))
    }
}

struct CurrentScoreView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentScoreView()
    }
}
