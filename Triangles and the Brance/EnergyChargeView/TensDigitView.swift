//
//  EnergyChargeTensDigitView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/08.
//

import SwiftUI


struct EnergyChargeTensDigitView: View {
    let isfirstOn: Bool
    let isSecondOn: Bool
    let length: CGFloat
    let distance: CGFloat

    // x:y = 1:sqrt(3)
    private var distanceY: CGFloat {
        distance / sqrt(3)
    }
    //-1 * (length/2 - distanceX)
    private var spacing: CGFloat {
        -0.5 * length + distance
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ZStack {
                Triangle()
                    .stroke(lineWidth: 1)
                if isfirstOn {
                    Triangle()
                }
            }
            .frame(width: length, height: length * sqrt(3) / 2 + distanceY)
            ZStack {
                Triangle()
                    .stroke(lineWidth: 1)
                    .rotationEffect(Angle(degrees: 180))
                if isSecondOn {
                    Triangle()
                        .rotationEffect(Angle(degrees: 180))
                }
            }
            .frame(width: length, height: length * sqrt(3) / 2 + distanceY)
        }
        .frame(width: 1.5 * length + distance, height: length * sqrt(3) / 2 + distanceY)
    }
    
    //frameのwidthのみで計算される、frameのheightを増やすとそこは余白になる
    private struct Triangle: Shape {
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.maxX, y: 0))
            path.addLine(to: CGPoint(x: rect.midX, y: sqrt(3) * rect.midX))
            path.addLine(to: rect.origin)
            return path
        }
    }
}

struct EnergyChargeTensDigitView_Previews: PreviewProvider {
    static var previews: some View {
        EnergyChargeTensDigitView(isfirstOn: true, isSecondOn: true, length: 100, distance: 20)
    }
}
