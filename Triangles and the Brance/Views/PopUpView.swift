//
//  PopUpView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/14.
//

import SwiftUI

struct PopUpView<Content:View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            }
            .padding(5)
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(white: 0.8))
            }
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView {
            Text("hello")
        }
    }
}
