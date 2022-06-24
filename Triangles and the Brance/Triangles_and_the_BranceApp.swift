//
//  Triangles_and_the_BranceApp.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

@main

struct Triangles_and_the_BranceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GameModel.shared.viewEnvironment)
                .onAppear{
                    let scenes = UIApplication.shared.connectedScenes
                    let windowScene = scenes.compactMap{
                        $0 as? UIWindowScene
                    }
                    if let window = windowScene.first!.windows
                        .first(where: {$0.isKeyWindow}) {
                        GameModel.shared.viewEnvironment.screenBounds = window.bounds
                    } else {
                        print("画面サイズ取得失敗")
                    }
                }
        }
    }
}
