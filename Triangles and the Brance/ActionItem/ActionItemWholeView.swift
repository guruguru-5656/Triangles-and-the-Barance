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
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: "bolt.batteryblock")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(stageModel.currentColor.heavy)
                        .frame(width: size * 0.06, height: size * 0.06)
                        .padding(.leading)
                    Spacer()
                    Text("\(stageModel.energy)")
                        .font(Font(UIFont.systemFont(ofSize: size / 14)))
                    Spacer()
                    ZStack {
                        if let text = energyDifferenceText {
                            Text(text)
                                .font(Font(UIFont.systemFont(ofSize: size / 20)))
                                .transition(.asymmetric(
                                    insertion: .offset(y: -10).combined(with: .opacity),
                                    removal: .opacity))
                        }
                    }
                    .frame(width: size * 0.1)
                }
                .frame(width: size * 0.35)
                .background{
                    RightCornerCutRectangle()
                        .foregroundColor(.backgroundLightGray)
                }
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
                    Color.backgroundLightGray
                    //                RectangleWithTextSpace(textSpaceWidth: size * 0.3, textSpaceHeight: size * 0.07)
                    //                    .foregroundColor(Color.backgroundLightGray)
                }
            }
           
            if let descriptionItem = itemController.descriptionItem {
                PopUpView {
                    DescriptionView(actionType: descriptionItem)
                }
                    .frame(width: size * 0.4, height: size * 0.35, alignment: .center)
                    .position(x: size * 0.5, y: size * 0.35)
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
