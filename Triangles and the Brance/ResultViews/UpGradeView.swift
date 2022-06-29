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
            VStack(spacing: 20) {
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
                        UpgradeSubView(item: $item)
                            .opacity(opacity)
                            .animation(.default.delay(Double(item.type.rawValue) * 0.1), value: opacity)
                    }
                }
                .frame(height: geometry.size.height / 2)
                HStack {
                    Button(action: {
                        upgradeModel.cancel()
                    }){
                        HStack {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 15)
                            
                            Text("Cancel")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color.heavyRed)
                    .border(Color.heavyRed, width: 2)
                    Button(action: {
                        upgradeModel.permitPaying()
                    }){
                        HStack {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 15)
                            Text("Upgrade")
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color.heavyGreen)
                    .border(Color.heavyGreen, width: 2)
                }
                .frame(height: 50)
                .padding()
            }
            .onAppear{
                opacity = 1
            }
        }
    }
}

struct UpgradeSubView: View {
    @Binding var item: UpgradeItemModel
    var body: some View {
        
        HStack {
            Text(item.text)
            Text(String(item.level))
            Spacer()
            Text(String(item.cost))
                .foregroundColor(item.isNextPayable ? Color.black : Color.red)
            Button(action: {
                item.upgrade()
            }){
                Image(systemName: "arrowtriangle.up")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(item.isUpdatable ? Color.heavyGreen : Color.gray)
                    .padding(5)
            }
            .disabled(!item.isUpdatable)
        }
        .frame(height: 40)
        .padding(.horizontal)
    }
}


struct UpGradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView()
    }
}
