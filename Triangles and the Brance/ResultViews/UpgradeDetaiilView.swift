//
//  UpgradeDetaiilView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/07/14.
//

import SwiftUI


struct UpGradeDetailView: View {
    
    @ObservedObject var model: UpgradeViewModel
    let size: CGSize
    var body: some View {
        PopUpView {
            VStack {
                HStack {
                    model.detailItem.icon
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .frame(width: size.width / 8)
                    Spacer()
                    GeometryReader { proxy in
                        Text(model.detailItem.effectDescriptionText)
                            .font(.caption)
                            .frame(width: proxy.size.width * 0.5, height: proxy.size.height * 0.7 , alignment: .bottomTrailing)
                        Text(model.detailItem.currentEffect)
                            .font(.title2)
                            .padding(.leading, 7)
                            .frame(width: proxy.size.width * 0.5, alignment: .leading)
                            .position(x: proxy.size.width * 0.75, y: proxy.size.height * 0.5)
                    }
                    Spacer()
                    Button(action: {
                        model.closeDetail()
                    }){
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(CustomListButton(width: 100))
                }
                .frame(height: size.width / 8)
                if let descriptionText = model.detailItem.descriptionText {
                    Text(descriptionText)
                }
                if let actionType = model.detailItem.type.actionType {
                    DescriptionView(actionType: actionType)
                        .frame(width: size.width * 0.4, height: size.width * 0.35)
                }
            }
        }
        .frame(width: size.width * 0.8 )
        .transition(.opacity)
    }
}
