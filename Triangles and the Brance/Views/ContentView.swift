//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/17.
//

import SwiftUI

struct ContentView: View {
    @State var mainView: MainView = .title
    var body: some View {
        switch mainView {
        case .title:
            TitleUIView(mainView: $mainView)
        case .game:
            GameView(mainView: $mainView)
        case .tutrial:
            TutrialView(mainView: $mainView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum MainView {
    case title
    case game
    case tutrial
    
    var bgm: BGMPlayer.Bgm {
        switch self {
        case .title:
            return .title
        case .game:
            return .stage
        case .tutrial:
            return .stage
        }
    }
}
