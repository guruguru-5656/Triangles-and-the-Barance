//
//  UpGradeView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import SwiftUI

struct UpgradeView: View {
    
    @Binding var showUpgradeView: Bool
    @StateObject var model = UpgradeViewModel()
    @State var opacity:Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Text("Point")
                        .font(.title)
                    Spacer()
                    Text(String(model.point))
                        .font(.title)
                    Spacer()
                }
                ZStack {
                    ScrollView {
                        ForEach($model.upgradeItems) { $item in
                            UpgradeCellView(item: $item, upgradeModel: model,height: geometry.size.width / 8)
                                .opacity(opacity)
                                .animation(.default.delay(Double(item.type.rawValue) * 0.1), value: opacity)
                        }
                    }
                    .frame(height: geometry.size.height * 0.6 )
                    if model.showDetailView {
                        UpGradeDetailView(model: model, size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.6))
                            .zIndex(1)
                    }
                }
                HStack(spacing: 20) {
                    Button(action: {
                        model.cancel()
                        withAnimation {
                            showUpgradeView = false
                        }
                    }){
                        HStack {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }
                        .foregroundColor(Color.heavyRed)
                    }
                    .buttonStyle(CustomButton())
                    
                    Button(action: {
                        model.permitPaying()
                        withAnimation {
                            showUpgradeView = false
                        }
                    }){
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Upgrade")
                        }
                        .foregroundColor(Color.heavyGreen)
                    }
                    .buttonStyle(CustomButton())
                    .overlay(Color(white: 0.5, opacity: model.payingPoint > 0 ? 0 : 0.2))
                }
                .frame(height: 50)
            }
            .onAppear{
                opacity = 1
            }
            .onTapGesture {
                if model.showDetailView == true {
                    model.closeDetail()
                }
            }
        }
    }
}

struct UpgradeCellView: View {
    
    @Binding var item: UpgradeCellViewModel
    @ObservedObject var upgradeModel: UpgradeViewModel
    let height: CGFloat
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                item.icon
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .frame(width: geometry.size.width / 8, height: geometry.size.width / 8)
                Text(item.descriptionText)
                    .font(.body)
                    .frame(width: geometry.size.width * 1/4)
                Text(item.currentEffect)
                    .frame(width: geometry.size.width / 10)
                Spacer()
                Text(String("\(item.level) / \(item.type.costList.count)"))
                    .frame(width: geometry.size.width / 8)
                Button(action: {
                    item.upgrade()
                }){
                    Text(item.costText)
                        .foregroundColor(item.isUpdatable ? Color.heavyGreen : Color.heavyRed)
                }
                .buttonStyle(CustomListButton(width: geometry.size.width * 3/8))
                .overlay {
                    Color(white: 0.5, opacity: item.isUpdatable ? 0 : 0.2)
                }
            }
        }
        .frame(height: height)
        .padding(.horizontal)
        .background(Color.white.opacity(0.7))
    }
}


struct UpGradeView_Previews: PreviewProvider {
    @State static var showUpgradeView = true
    static var previews: some View {
        UpgradeView(showUpgradeView: $showUpgradeView)
    }
}
