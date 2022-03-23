//
//  ContentView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/03/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    var body: some View {
        VStack{
//            Button(action: {contentViewModel.resetStage()}){
                Rectangle()
                    .frame(width: 50, height: 50, alignment: .center)
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(.lightRed)
                    .padding(30)
//            }
        }
        StageView()
            .environmentObject(contentViewModel.stage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
