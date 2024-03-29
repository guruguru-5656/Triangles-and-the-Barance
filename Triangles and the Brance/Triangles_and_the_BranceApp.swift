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
                .preferredColorScheme(.light)
                .onAppear {
                    //バージョンアップに伴って、不要になったデータを削除する処理
                    UserData.removeUnusedData()
                }
        }
    }
}
