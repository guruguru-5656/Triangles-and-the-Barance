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
                    Spacer()
                    HStack {
                        Section {
                            Text(String(tutrialModel.life))
                                .font(Font(UIFont.monospacedSystemFont(ofSize: 35.0, weight: .regular)))
                                .foregroundColor(tutrialModel.life <= 1 ? Color.red : Color(white: 0.3))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                                .background(
                                    Rectangle()
                                        .stroke()
                                        .foregroundColor(tutrialModel.currentColor.heavy)
                                        .background(Color.backgroundLightGray.scaleEffect(1.2))
                                        .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                        .rotationEffect(Angle(degrees: 45)))
                        }
                        .modifier(TutrialViewSpace(key: .lifeView))
                        Spacer()
                        Text("Tutrial")
                            .font(.largeTitle)
                            .foregroundColor(Color(white: 0.3))
                        Spacer()
                        
                    }
                    .padding(.horizontal, geometry.size.width / 16)
                    Spacer()
                    Section {
                        TriangleView()
                            .modifier(TutrialViewSpace(key: .triangleView))
                            .padding(.horizontal, geometry.size.width / 10)
                    }
                    .frame(width: geometry.size.width ,height: geometry.size.width * 0.75)
                    Spacer()
                    ActionItemWholeView(size: geometry.size.width)
                        .frame( height: geometry.size.width * 0.22)
                        .modifier(TutrialViewSpace(key: .itemView))
                        .zIndex(1)
                    Spacer()
                    BaranceView()
                        .padding(.horizontal, geometry.size.width * 0.1)
                        .frame(height: geometry.size.width * 0.35)
                        .modifier(TutrialViewSpace(key: .baranceView))
                    Spacer()
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
                        Text(tutrialModel.description.text)
                            .multilineTextAlignment(.leading)
                    }
                    .onTapGesture {
                        tutrialModel.continueTutrial(.next)
                    }
                    .padding()
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * textPosition)
                }
                .ignoresSafeArea()
                ZStack() {
                    Button(action: {
                        soundPlayer.play(sound: .selectSound)
                        withAnimation {
                            isShowPopup = true
                        }
                    }){
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .resizable()
                            .foregroundColor(.backgroundLightGray)
                            .frame(width: geometry.size.width * 0.07, height: geometry.size.width * 0.07)
                    }
                }
                .padding(geometry.size.width * 0.1)
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
                    .padding()
                }
            }
        }
        .onPreferenceChange(ClearCirclePoint.self) { value in
            circleAncor = value
        }
        .onPreferenceChange(TutrialPreferenceKey.self){ value in
            anchors = value
        }
        .environmentObject(tutrialModel as StageModel)
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
