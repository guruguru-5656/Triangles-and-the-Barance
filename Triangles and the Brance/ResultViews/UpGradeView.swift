//
//  UpGradeView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/04/04.
//

import SwiftUI

struct UpgradeView: View {
    @ObservedObject var upgradeModel:UpgradeViewModel  = GameModel.shared.upgradeModel
    @State var opacity:Double = 0
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                Text("所持金")
                Text(String(upgradeModel.money))
                Spacer()
                Text("支払い金額")
                Text(String(upgradeModel.payingMoney))
                Spacer()
            }
            .font(.title)
            ForEach($upgradeModel.upgradeItems) { $item in
                UpgradeSubView(item: $item)
                    .opacity(opacity)
                    .animation(.default.delay(Double(item.id) * 0.1), value: opacity)
            }
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
                            .font(.title)
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
                            .font(.title)
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

struct UpgradeSubView: View {
    @Binding var item: UpgradeItemViewModel
    var body: some View {
        
        HStack {
            Text(item.upgradeStatus.text)
            Text(String(item.upgradeStatus.level))
            Spacer()
            Text(String(item.cost))
                .foregroundColor(item.isNextPayable ? Color.black : Color.red)
            Button(action: {
                item.upgrade()
                print(item.isUpdatable)
                print(item.isNextPayable)
                print((item.upgradeStatus.level + 1) <= item.upgradeStatus.upgradeRange.upperBound )
            }){
                Image(systemName: "arrowtriangle.up")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(item.isUpdatable ? Color.lightGreen : Color.gray)
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
