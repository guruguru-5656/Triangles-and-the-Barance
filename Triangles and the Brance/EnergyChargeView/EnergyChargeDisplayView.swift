//
//  EnergyChargeDisplayView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/07.
//

import SwiftUI


struct EnergyChargeDisplayView: View {
    let energy: Int
    let stageColor: StageColor

    private var isFirstOn: Bool {
        energy >= 10
    }
    private var isSecondOn: Bool {
        energy >= 20
    }
    private var isEnergyMax: Bool {
        energy > 29
    }
  
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: geometry.size.width * 0.05) {
                EnergyChargeTensDigitView(isfirstOn: isFirstOn, isSecondOn: isSecondOn, length: geometry.size.width * 0.1 , distance: 10)
                    .foregroundColor(stageColor.heavy)
                EnergyChargeOnesDigitView(energy: energy, stageColor: stageColor)
                    .frame(width: geometry.size.width * 0.7)
                if isEnergyMax {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 5)
                        .frame(width: geometry.size.width * 0.07, height: geometry.size.height, alignment: .top)
                        .foregroundColor(stageColor.heavy)
                        .offset(x: -0.1 * geometry.size.width)
                }
            }
        }
    }
}

struct EnergyChargeDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        EnergyChargeDisplayView(energy: 30, stageColor: StageColor(stage: 1))
            .frame(width: 300, height: 80)
            .background(Color.lightGreen)
    }
}
