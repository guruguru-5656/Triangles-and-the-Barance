//
//  ActionItemAllOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/20.
//

import SwiftUI

import SwiftUI
import Combine

struct ActionItemWholeView: View {
    
    @StateObject var itemController = ItemController()
    @State var text: String = ""
    @EnvironmentObject var stageModel: StageModel
    let size: CGFloat
    var energyDifferenceText: String? {
        guard let energyDiffernce = itemController.energyDifference else {
            return nil
        }
        if energyDiffernce < 0 {
            return "\(energyDiffernce)"
        } else if energyDiffernce == 0 {
            return nil
        } else {
            return "+\(energyDiffernce)"
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach($itemController.actionItems, id: \.self){ $item in
                        ActionItemView(itemModel: $item, size: size / 8)
                            .padding(.leading, 15)
                            .onTapGesture {
                                itemController.itemSelect(model: item)
                            }
                            .onLongPressGesture {
                                itemController.showDescriptionView(item: item)
                            }
                    }
                }
            }
            .background{
                RectangleWithTextSpace(textSpaceWidth: size * 0.25, textSpaceHeight: size * 0.07)
                    .foregroundColor(Color.backgroundLightGray)
            }
            Text("\(stageModel.energy)")
                .position(x: size * 0.17, y: size * -0.03)
                .font(Font(UIFont.systemFont(ofSize: size / 14)))
            if let text = energyDifferenceText {
            Text(text)
                    .position(x: size * 0.08, y: size * -0.03)
                .font(Font(UIFont.systemFont(ofSize: size / 20)))
                .transition(.asymmetric(
                    insertion: .offset(y: -10).combined(with: .opacity),
                    removal: .opacity))
            }
            if let descriptionItem = itemController.descriptionItem {
                DescriptionView(actionType: descriptionItem)
                    .frame(width: size * 0.4, height: size * 0.4, alignment: .center)
                    .position(x: size * 0.5, y: size * 0.5)
                    .onTapGesture {
                        itemController.closeDescriptionView()
                    }
            }
        }
        .onAppear {
            itemController.subscribe(stageModel: stageModel)
        }
    }
}

struct ActionItemAllOverView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemWholeView(size: 300)
            .environmentObject(StageModel())
    }
}
