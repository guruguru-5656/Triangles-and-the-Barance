//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject var stage = StageModel.setUp
    var body: some View {
        Text("Hello, world!")
            .padding()
        StageView()
            .environmentObject(stage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
