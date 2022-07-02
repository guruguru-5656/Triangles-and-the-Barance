//
//  ActionItemAllOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/20.
//

import SwiftUI

import SwiftUI

struct ActionItemAllOverView: View {
    
    @ObservedObject var itemController = GameModel.shared.itemController
    let size: CGFloat
    var inventoryPercentage:Double {
        Double(itemController.actionItems.count) / Double(itemController.inventory)
    }
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ActionItemView(itemModel: itemController.normalActionItem, size: geometry.size.height)
                    .padding(.leading, geometry.size.height / 4)
                    .padding(.trailing, geometry.size.height / 8)
                Divider().background(Color(white : 0.1))
                ForEach(itemController.actionItems,id: \.self){ item in
                    ActionItemView(itemModel: item, size: geometry.size.height)
                        .padding(.leading, 15)
                    
                }
            }
            Text("\(itemController.actionItems.count)/\(itemController.inventory)")
                .position(x: size * 7/8, y: size * -1/24)
                .font(Font(UIFont.monospacedSystemFont(ofSize: size / 20, weight: .regular)))
                .foregroundColor(inventoryPercentage >= 1 ? .red : .black)
        }
        .frame(width: size, height: size / 8)
        .padding(size / 32)
        .background{
            RectangleWithTwoTextSpace(textSpaceWidth: size / 4, textSpaceHeight: size / 24)
                .foregroundColor(Color.backgroundLightGray)
        }
    }
}

struct ActionItemAllOverView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemAllOverView(size: 300)
            .environmentObject(GameModel.shared.viewEnvironment)
    }
}
