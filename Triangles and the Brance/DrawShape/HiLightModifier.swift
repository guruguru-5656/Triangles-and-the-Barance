//
//  HiLightModifier.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/12.
//

import SwiftUI


struct HiLightModifier: ViewModifier {
    @Binding var isHilighted: Bool
    @State var opacity: Double = 0
    
    
    func body(content: Content) -> some View {
        content
            .overlay {
//                if isHilighted {
                    content
//                        .foregroundColor(.white)
                        .scaleEffect(1.5)
//                        .animation(.linear(duration: 0.3).repeatForever(), value: )
                        .opacity(opacity)
                        .animation(.linear(duration: 0.3).repeatForever(), value: opacity)
//                        .blur(radius: 20)
                        .onAppear{
//                            withAnimation(.linear(duration: 0.5).repeatForever()){
                            opacity = 1
//                            }
                        }
                        .onDisappear{
                            opacity = 0
                        }
                        }
//            }
    }
    
}
