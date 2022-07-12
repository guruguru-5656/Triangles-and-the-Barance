//
//  ActionItemAllOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/20.
//

import SwiftUI

import SwiftUI

struct ActionItemWholeView: View {
    
    @ObservedObject var itemController = GameModel.shared.itemController
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    ForEach($itemController.actionItems, id: \.self){ $item in
                        ActionItemView(itemModel: $item, size: size / 8)
                            .padding(.leading, 15)
                    }
                }
            }
            Text("\(itemController.energy)")
                .position(x: size * 0.9, y: size * -1/30)
                .font(Font(UIFont.systemFont(ofSize: size / 16)))
        }
        .background{
            RectangleWithTextSpace(textSpaceWidth: size / 4, textSpaceHeight: size / 15)
                .foregroundColor(Color.backgroundLightGray)
        }
    }
}

struct ActionItemAllOverView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemWholeView(size: 300)
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
