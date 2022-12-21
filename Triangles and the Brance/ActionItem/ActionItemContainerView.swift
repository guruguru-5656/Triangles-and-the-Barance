//
//  ActionItemAllOverView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/06/20.
//

import SwiftUI

import SwiftUI
import Combine

struct ActionItemContainerView: View {
    @State var text: String = ""
    @EnvironmentObject var gameModel: GameModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Image(systemName: "bolt.batteryblock")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(gameModel.currentColor.heavy)
                            .padding(.vertical, 8)
                            .padding(.leading, geometry.size.width * 0.02)
                        Text(String(format: " %2d",gameModel.stageStatus.energy))
                            .font(.monospaced(.title2)())
                            .foregroundColor(gameModel.currentColor.heavy)
                            .padding(.trailing, geometry.size.width * 0.04)
                        EnergyChargeDisplayView(energy: gameModel.stageStatus.energy, stageColor: gameModel.currentColor)
                            .frame(width: geometry.size.width * 0.6)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.1)
                    .background(Color.backgroundLightGray)
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack {
                            ForEach($gameModel.actionItems, id: \.self){ $item in
                                ActionItemView(itemModel: $item, size: geometry.size.width / 8)
                                    .padding(.leading, 15)
                                    .onTapGesture {
                                        gameModel.itemSelect(model: item)
                                    }
                            }
                        }
                    }
                    .background(Color.backgroundLightGray)
                }
                if let selectedItem = gameModel.selectedItem{
                    PopUpView {
                        DescriptionView(actionType: selectedItem.type)
                    }
                    .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.32, alignment: .center)
                    .offset(y: geometry.size.height)
                }
            }
        }
    }
}

struct ActionItemAllOverView_Previews: PreviewProvider {
    static var previews: some View {
        ActionItemContainerView()
            .environmentObject(GameModel())
    }
}
