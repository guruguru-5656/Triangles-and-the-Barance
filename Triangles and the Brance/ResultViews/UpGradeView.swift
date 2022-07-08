//
//  UpGradeView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import SwiftUI

struct UpgradeView: View {
    @ObservedObject var upgradeModel = UpgradeViewModel()
    @State var opacity:Double = 0
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("ポイント")
                            .font(.title2)
                        Text(String(upgradeModel.money))
                            .font(.title2)
                    }
                    Spacer()
                    VStack {
                        Text("使用ポイント")
                            .font(.title2)
                        Text(String(upgradeModel.payingMoney))
                            .font(.title2)
                    }
                    Spacer()
                }
                .font(.title)
                ScrollView {
                    ForEach($upgradeModel.upgradeItems) { $item in
                        UpgradeSubView(item: $item, geometrySize: geometry.size)
                            .opacity(opacity)
                            .animation(.default.delay(Double(item.type.rawValue) * 0.1), value: opacity)
                    }
                }
                .frame(height: geometry.size.height * 0.6)
                HStack(spacing: 20) {
                    Button(action: {
                        upgradeModel.cancel()
                    }){
                        HStack {
                            Image(systemName: "xmark")
               
                            Text("Cancel")
                            
                        }
                        .foregroundColor(Color.heavyRed)
                    }
                    .buttonStyle(CustomButton())
                    
                    Button(action: {
                        upgradeModel.permitPaying()
                    }){
                        HStack {
                            Image(systemName: "checkmark")
                    
                            Text("Upgrade")
                            
                        }
                        .foregroundColor(Color.heavyGreen)
                    }
                    .buttonStyle(CustomButton())
                    
                }
                .frame(height: 50)
             
            }
            .onAppear{
                opacity = 1
            }
        }
    }
}

struct UpgradeSubView: View {
    @Binding var item: UpgradeItemModel
    let geometrySize: CGSize
    var body: some View {
        HStack {
            
            item.icon
                .resizable()
                .scaledToFit()
                .padding(5)
                .frame(width: geometrySize.width / 8)
            Text(item.descriptionText)
                .font(.body)
            Spacer()
            Text(item.currentEffect)
            Spacer()
            Text(String("\(item.level) / \(item.type.upgradeRange.upperBound)"))
            Button(action: {
                item.upgrade()
            }){
                Text(String(format: "%8d", item.cost))
                    .foregroundColor(item.isUpdatable ? Color.heavyGreen : Color.heavyRed)
            }
            .buttonStyle(CustomListButton())
            .disabled(!item.isUpdatable)
            .overlay {
                Color(white: 0.5, opacity: item.isUpdatable ? 0 : 0.2)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
    
}


struct UpGradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView()
    }
}
