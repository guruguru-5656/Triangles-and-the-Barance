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
                            UpgradeCellView(item: $item,height: geometry.size.width / 6)
                                .opacity(opacity)
                                .animation(.default.delay(Double(item.type.rawValue) * 0.1), value: opacity)
                        }
                    }
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
                .padding(.vertical)
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
    let height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                item.icon
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 8)
                    .padding(.leading, 8)
                    .frame(width: geometry.size.height - 8, height: geometry.size.height)
                    .onTapGesture {
                        item.showDetail()
                    }
                Spacer()
                GeometryReader { proxy in
                    Text(item.effectDescriptionText)
                        .font(.caption)
                        .frame(width: proxy.size.width * 0.5, height: proxy.size.height * 0.7 , alignment: .bottomTrailing)
                    Text(item.currentEffect)
                        .font(.title2)
                        .padding(.leading, 7)
                        .frame(width: proxy.size.width * 0.5, alignment: .leading)
                        .position(x: proxy.size.width * 0.75, y: proxy.size.height * 0.5)
                }
                .frame(width: geometry.size.width * 0.35 , height: geometry.size.height)
                .background(Color(white: 0.9))
                Spacer()
                Button(action: {
                    item.upgrade()
                    item.playUpgradeSound()
                }){
                    Text(item.costText)
                        .foregroundColor(item.isUpdatable ? Color.heavyGreen : Color.heavyRed)
                }
                .buttonStyle(CustomListButton(width: geometry.size.width * 0.4))
                .overlay {
                    Color(white: 0.5, opacity: item.isUpdatable ? 0 : 0.2)
                }
            }
        }
        .frame(height: height)
        .padding(.horizontal)
        .background {
            Color.white.opacity(0.7)
        }
    }
}


struct UpGradeView_Previews: PreviewProvider {
    @State static var showUpgradeView = true
    static var previews: some View {
        UpgradeView(showUpgradeView: $showUpgradeView)
    }
}
