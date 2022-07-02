//
//  ActionItemShurikenView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/01.
//

import SwiftUI

struct ActionItemShurikenView: View {
    @EnvironmentObject var viewEnvironment: ViewEnvironment
    let size:CGFloat
    
    var body: some View {
        ZStack {
            TriangleNormalShape()
                .frame(width: size, height: size)
                .foregroundColor(viewEnvironment.currentColor.light)
            ShurikenShape()
                .stroke(viewEnvironment.currentColor.heavy, lineWidth: 2)
                .frame(width: size * 0.4, height: size * 0.4 * sqrt(3)/2)
                .offset(y:size * 0.03)
        }
    }
}

struct ShurikenShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.width * 1/6, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height * 2/3))
        path.move(to: CGPoint(x: rect.width * 5/6, y: rect.height * 2/3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 1/3))
        path.addLine(to: CGPoint(x: rect.width * 1/3, y: rect.height * 1/3))
        path.move(to: CGPoint(x: rect.width * 1/6, y: rect.height * 2/3))
        path.addLine(to: CGPoint(x: rect.width * 1/3, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 2/3, y: rect.height * 1/3))
        return path
    }
}



struct ActionItemShurikenView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemShurikenView(size: 200)
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
