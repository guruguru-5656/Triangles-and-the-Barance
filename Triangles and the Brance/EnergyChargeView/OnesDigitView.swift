//
//  EnergyChargeOnesDiditView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/08.
//

import SwiftUI

struct EnergyChargeOnesDigitView: View {
    let energy: Int
    let stageColor: StageColor
  
    private var models: [Model] {
        let ones = energy > 29 ? 9 : energy % 10
        return [Int](1...9).map { Model(isOn: $0 <= ones) }
    }
  
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(models) { model in
                    EnergyDistanceCellView(isOn: model.isOn, stageColor: stageColor)
                        .frame(width: geometry.size.width / 10)
                }
            }
        }
    }
    
    struct Model: Identifiable {
        let id = UUID()
        let isOn: Bool
    }
}

struct EnergyChargeOnesDigitView_Previews: PreviewProvider {
    static var previews: some View {
        EnergyChargeOnesDigitView(energy: 27, stageColor: StageColor(stage: 1))
    }
}


struct EnergyDistanceCellView: View {
    let isOn: Bool
    let stageColor: StageColor
    
    var body: some View {
        ZStack {
            if isOn {
                CellShape()
                    .foregroundColor(stageColor.light)
            }
            CellShape()
                .stroke(stageColor.heavy, lineWidth: 1)
        }
    }
    
    struct CellShape: Shape {
        
        func path(in rect: CGRect) -> Path {
            let distance = rect.height / sqrt(3)
            var path = Path()
            path.move(to: CGPoint(x: -distance, y: 0))
            path.addLine(to: CGPoint(x: -distance + rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
            return path
        }
    }
}
