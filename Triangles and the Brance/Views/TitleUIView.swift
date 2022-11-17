//
//  TitleUIView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/04.
//

import SwiftUI

struct TitleUIView: View {
    let titleColor = StageColor(stage: 1)
    @State private var isGameViewActive = false
    @State private var isTutrialViewActive = false
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ZStack {
                    titleColor.previousColor.heavy
                        .ignoresSafeArea()
                    LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.3)
                        .ignoresSafeArea()
                    VStack {
                        Spacer()
                        GeometryReader { geometry in
                            let baseScale: CGFloat = geometry.size.width / 8
                            //左右に伸びる棒
                            Group {
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(width: baseScale / 8, height: baseScale * 1.5)
                                    .position(x: baseScale * 1, y: baseScale * 1.25)
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(width: baseScale / 8, height: baseScale * 1.5)
                                    .position(x: baseScale * 7, y: baseScale * 1.25)
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(.lightGray)
                                    .frame(width: baseScale * 6.5, height: baseScale / 4)
                                    .position(x: baseScale * 4, y: baseScale * 0.5)
                            }
                            //中央部分
                            Group {
                                Rectangle()
                                    .foregroundColor(.lightGray)
                                    .frame(width: baseScale / 4, height: baseScale * 2)
                                    .position(x: baseScale * 4, y: baseScale * 1.5)
                                TriangleNormalShape()
                                    .frame(width: baseScale * 2, height: baseScale * 2 * sqrt(3)/2)
                                    .foregroundColor(titleColor.light)
                                    .position(x:baseScale * 4, y: baseScale * 2.8)
                                RegularPolygon(vertexNumber: 6)
                                    .foregroundColor(.gray)
                                    .frame(width:baseScale * 0.8, height:baseScale * 0.8)
                                    .position(x: baseScale * 4, y: baseScale * 0.5)
                            }
                            //右側
                            TriangleNormalShape()
                                .foregroundColor(.gray)
                                .frame(width: baseScale * sqrt(3), height: baseScale *
                                       1.5 )
                                .position(x: baseScale * 7, y: baseScale * 2)
                            //左側の三角形
                            TriangleNormalShape()
                                .foregroundColor(.backgroundLightGray)
                                .rotationEffect(Angle(degrees: 180))
                            
                                .frame(width: baseScale * sqrt(3), height: baseScale *  1.5 )
                                .position(x: baseScale * 1, y: baseScale * 1.8)
                            
                        }
                        .frame(height: proxy.size.width * 0.5)
                        .padding()
                        HStack(spacing: 30) {
                            NavigationLink( isActive: $isGameViewActive,
                                            destination: { GameView() },
                                            label: {
                                Button(action: {
                                    var transaction = Transaction()
                                    transaction.disablesAnimations = true
                                    withTransaction(transaction) {
                                        isGameViewActive = true
                                    }
                                }){
                                    HStack {
                                        Image(systemName: "arrowtriangle.up")
                                        Text("START")
                                    }
                                    .foregroundColor(Color.heavyRed)
                                }
                                .buttonStyle(CustomButton())
                            })
                            NavigationLink( isActive: $isTutrialViewActive,
                                            destination: { TutrialView() },
                                            label: {
                                Button(action: {
                                    var transaction = Transaction()
                                    transaction.disablesAnimations = true
                                    withTransaction(transaction) {
                                        isTutrialViewActive = true
                                    }
                                },
                                       label: {
                                    HStack {
                                        Image(systemName:"book")
                                        Text("TUTRIAL")
                                    }
                                    .foregroundColor(.heavyGreen)
                                })
                                .buttonStyle(CustomButton())
                            })
                            
                        }
                        .frame(width: proxy.size.width ,height: 100)
                        .background(Color.lightGray)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct TitleUIView_Previews: PreviewProvider {
    static var previews: some View {
        TitleUIView()
    }
}
