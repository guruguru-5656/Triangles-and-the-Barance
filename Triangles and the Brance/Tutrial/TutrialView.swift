//
//  TutrialView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/11/14.
//

import SwiftUI

struct TutrialView: View {
    
    @Binding var mainView: MainView
    @ObservedObject var tutrialModel = TutrialViewModel()
    @State private var circleAncor: Anchor<CGRect>?
    @State private var anchors: [TutrialGeometryKey: Anchor<CGRect>] = [:]
    @State private var isShowPopup = false
    private let soundPlayer = SoundPlayer.instance
    
    private var textPosition: Double {
        switch tutrialModel.description.textPosition {
        case .up:
            return 0.55
        case .down:
            return 0.65
        case .none:
            return 1
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                //背景
                tutrialModel.currentColor.previousColor.heavy
                    .ignoresSafeArea()
                if let circleAncor = circleAncor {
                    let rect = geometry[circleAncor]
                    let point = CGPoint(x: rect.origin.x + rect.width/8, y: rect.origin.y + rect.width * 3/8)
                    BaranceCircleView(circlePoint: point)
                }
                LinearGradient(colors:[.white, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(0.3)
                    .ignoresSafeArea()
                //ステージ
                VStack(alignment: .center) {
                  HStack {
                      ZStack {
                            Rectangle()
                                .stroke()
                                .foregroundColor(tutrialModel.currentColor.heavy)
                                .background(Color.backgroundLightGray.scaleEffect(1.2))
                                .frame(width: geometry.size.width * 0.11, height: geometry.size.width * 0.11)
                                .rotationEffect(Angle(degrees: 45))
                            Text(String(tutrialModel.stageStatus.life))
                                .font(Font(UIFont.monospacedSystemFont(ofSize: geometry.size.width * 0.08, weight: .regular)))
                                .foregroundColor(tutrialModel.stageStatus.life <= 1 ? Color.red : Color(white: 0.3))
                                .frame(width: geometry.size.width * 0.11, height: geometry.size.width * 0.11)
                        }
                      .modifier(TutrialViewSpace(key: .lifeView))
                      .padding(.horizontal, 20)
                      .padding(.vertical, 5)
                        Spacer()
                        Text("Tutrial")
                            .font(Font(UIFont.systemFont(ofSize: geometry.size.width * 0.09)))
                            .foregroundColor(Color(white: 0.3))
                            .offset(x: geometry.size.width * -0.03)
                        Spacer()
                      Color.clear
                            .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
                            .anchorPreference(key: ButtonFramePreferenceKey.self ,value: Anchor.Source.bounds , transform:  { $0 })
                    }
                    .padding(.horizontal, geometry.size.width / 16)
                    .padding(.top)
                    Spacer()
                    TriangleView()
                        .modifier(TutrialViewSpace(key: .triangleView))
                        .padding(.horizontal, geometry.size.width / 10)
                        .frame(height: geometry.size.width * 0.7)
                    Spacer()
                    ActionItemWholeView()
                        .frame(height: geometry.size.width * 0.33)
                        .modifier(TutrialViewSpace(key: .itemView))
                        .zIndex(1)
                    Spacer()
                    BaranceView()
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .frame(height: geometry.size.width * 0.35)
                        .modifier(TutrialViewSpace(key: .baranceView))
                }
                
                Section {
                    //説明している場所以外をカバーするView
                    if let geometryKey = tutrialModel.description.geometryKey {
                        TutrialCoverView(anchor: anchors[geometryKey]!)
                            .onTapGesture {
                                print("coverViewTapped")
                                //何もしない
                            }
                    }
                    else {
                        Color.black
                            .opacity(0.3)
                            .onTapGesture {
                                print("coverViewTapped")
                                //何もしない
                            }
                    }
                        PopUpView {
                            ZStack (alignment: .bottomTrailing) {
                                Text(tutrialModel.description.text + " ")
                                    .multilineTextAlignment(.leading)
                                if tutrialModel.description.flag == .next {
                                        TriangleNormalShape()
                                        .frame(width: 15, height: 7.5 * sqrt(3))
                                        .rotationEffect(Angle(degrees: 180))
                                        .padding(3)
                                        .foregroundColor(Color(white: 0.3))
                                        .offset(x: 15, y: 10)
                                }
                            }
                        }
                        .onTapGesture {
                            tutrialModel.continueTutrial(.next)
                        }
                        .padding()
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * textPosition)
                }
                .ignoresSafeArea()

                if isShowPopup {
                        PopUpView {
                            HStack(spacing: 20) {
                                Button(action: {
                                    soundPlayer.play(sound: .cancelSound)
                                    withAnimation {
                                        isShowPopup = false
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
                                    soundPlayer.play(sound: .decideSound)
                                    tutrialModel.exit()
                                }){
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                        Text("Exit")
                                    }
                                    .foregroundColor(Color.heavyGreen)
                                }
                                .buttonStyle(CustomButton())
                            }
                            .frame(height: 50)
                        }
                        .position(x: geometry.size.width * 0.5,
                                  y: geometry.size.height * 0.5)
                }
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { value in
            circleAncor = value
        }
        .onPreferenceChange(TutrialPreferenceKey.self){ value in
            anchors = value
        }
        .overlayPreferenceValue(ButtonFramePreferenceKey.self) { anchor in
            GeometryReader { geometry in
                if let anchor = anchor {
                    Button(action: {
                        soundPlayer.play(sound: .selectSound)
                        withAnimation {
                            isShowPopup = true
                        }
                    }){
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .resizable()
                            .foregroundColor(.backgroundLightGray)
                    }
                    .frame(width: geometry[anchor].width, height: geometry[anchor].height)
                    .position(x: geometry[anchor].midX, y: geometry[anchor].midY)
                }
            }
        }
        .environmentObject(tutrialModel as GameModel)
        .navigationBarHidden(true)
        .onReceive(tutrialModel.$isPresented) { isPresented in
            if isPresented == false {
                mainView = .title
            }
        }
    }
}

struct TutrialView_Previews: PreviewProvider {
    @State static private var mainView: MainView = .tutrial
    static var previews: some View {
        TutrialView(mainView: $mainView)
    }
}
