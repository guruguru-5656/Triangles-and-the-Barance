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
                    HStack {
                        Image(systemName: "bolt.batteryblock")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(gameModel.currentColor.heavy)
                            .padding(8)
                            .padding(.horizontal, geometry.size.width * 0.04)
                        EnergyChargeDisplayView(energy: gameModel.stageStatus.energy, stageColor: gameModel.currentColor)
                            .frame(width: geometry.size.width * 0.7)
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.1)
                    .background(Color.backgroundLightGray)
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
