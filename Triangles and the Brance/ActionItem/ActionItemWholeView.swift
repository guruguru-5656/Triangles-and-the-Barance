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
    @EnvironmentObject var gameModel: GameModel
    
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
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 2) {
                    ZStack(alignment: .bottom) {
                        HStack(alignment: .bottom) {
                            Spacer()
                            Text("score: " + String(format: "%08d", gameModel.stageScore.score))
                                .padding(.trailing)
                                .frame(width: geometry.size.width * 0.64, height: geometry.size.width * 0.06, alignment: .trailing)
                                .background(Color.gray)
                        }
                        HStack {
                            HStack {
                                Image(systemName: "bolt.batteryblock")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(gameModel.currentColor.heavy)
                                    .padding(8)
                                    .padding(.leading, 5)
                                Spacer()
                                Text("\(gameModel.stageStatus.energy)")
                                    .font(Font(UIFont.systemFont(ofSize: geometry.size.width / 15)))
                                Spacer()
                                ZStack {
                                    if let text = energyDifferenceText {
                                        Text(text)
                                            .font(Font(UIFont.systemFont(ofSize: geometry.size.width / 20)))
                                            .transition(.asymmetric(
                                                insertion: .offset(y: -10).combined(with: .opacity),
                                                removal: .opacity))
                                    }
                                }
                                .frame(width: geometry.size.width * 0.1, alignment: .bottomLeading)
                            }
                            .background{
                                RightCornerCutRectangle()
                                    .foregroundColor(.backgroundLightGray)
                            }
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.1)
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.width * 0.1)
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack {
                            ForEach($itemController.actionItems, id: \.self){ $item in
                                ActionItemView(itemModel: $item, size: geometry.size.width / 8)
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
                    .background(Color.backgroundLightGray)
                }
                if let descriptionItem = itemController.descriptionItem {
                    PopUpView {
                        DescriptionView(actionType: descriptionItem)
                    }
                    .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.32, alignment: .center)
                    .onTapGesture {
                        itemController.closeDescriptionView()
                    }
                }
            }
        }
        .onAppear {
            itemController.subscribe(gameModel: gameModel)
        }
    }
}

struct ActionItemAllOverView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemWholeView()
            .environmentObject(GameModel())
    }
}
