//
//  ShowUpgradableButtonView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/05.
//

import SwiftUI

struct ShowUpgradableButtonView: View {
    @StateObject private var model = UpgradableButtonViewModel()
    let action: () -> Void
    
    var body: some View {
        ZStack {
            if model.upgradable {
                HilightFrameView()
            }
            Button(action: {
                action()
            }){
                HStack {
                    Image(systemName: "arrowtriangle.up")
                    Text("Upgrade")
                }
                .foregroundColor(.heavyGreen)
            }
            .buttonStyle(CustomButton())
        }
        .onAppear {
            model.setUpgradable()
        }
    }
}

struct ShowUpgradableButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShowUpgradableButtonView(action: {})
    }
}

class UpgradableButtonViewModel: ObservableObject {
    @Published var upgradable = false
    private let saveData: DataClass
    init(saveData: DataClass = SaveData.shared) {
        self.saveData = saveData
    }
     
    func setUpgradable() {
        let point = saveData.loadData(name: ResultValue.totalPoint)
        let upgradeCosts: [Int] = UpgradeType.allCases.compactMap { type in
            let levelData = saveData.loadData(name: type)
            //強化がmaxの場合はcostListの範囲外となるため除外
            if type.costList.indices.contains(levelData) {
                return type.costList[levelData]
            }
            return nil
        }
        withAnimation {
            upgradable = !upgradeCosts.allSatisfy {
                $0 > point
            }
        }
    }
}

struct HilightFrameView: View {
    @State private var scale: Double = 1
    @State private var opacity: Double = 0.5
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 2)
            .foregroundColor(.heavyGreen)
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(.easeOut(duration: 1.2).repeatForever(autoreverses: false), value: scale)
            .animation(.easeOut(duration: 1.2).repeatForever(autoreverses: false), value: opacity)
            .onAppear {
                scale = 1.2
                opacity = 0
            }
    }
}
