//
//  CustomButton.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/06.
//

import SwiftUI

struct CustomButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .padding(8)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color(white: 0.5))
                }
                    .opacity(0.5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}

struct CustomListButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, design: .monospaced))
            .padding(8)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color(white: 0.6))
                        .scaleEffect(1.02)
                        .offset(y: 1)
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(Color(white: 0.9))
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}

