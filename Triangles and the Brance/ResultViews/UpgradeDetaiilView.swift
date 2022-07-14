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
        VStack {
            HStack {
                model.detailItem.icon
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .frame(width: size.width / 8)
                Text(model.detailItem.descriptionText)
                    .font(.body)
                Spacer()
                Text(model.detailItem.currentEffect)
                Spacer()
                Text(String("\(model.detailItem.level) / \(model.detailItem.type.upgradeRange.upperBound)"))
                Button(action: {
                    model.closeDetail()
                }){
                   Image(systemName: "xmark")
                }
                .buttonStyle(CustomListButton())
            }
            .padding(10)
            if let actionType = model.detailItem.actionType {
                DescriptionView(actionType: actionType)
                    .frame(width: size.width * 0.4, height: size.width * 0.4)
            }
        }
        .frame(width: size.width * 0.8 )
        .background{
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(white: 0.98))
        }
        .transition(.move(edge: .leading))
    }
}
