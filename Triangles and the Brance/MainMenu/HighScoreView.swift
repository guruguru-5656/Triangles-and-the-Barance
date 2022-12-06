//
//  HiScoreView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/01.
//

import SwiftUI

struct HighScoreView: View {
    @State private var opacity: Double = 0
    @StateObject private var model = HighScoreViewModel()
    @Binding var isShow: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("High Score")
                    .font(.largeTitle)
                    .padding(.vertical)
                    .background {
                        Rectangle()
                            .frame(width: geometry.size.width)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                Section {
                    ForEach($model.results) { $results in
                        ScoreView(score: $results)
                            .opacity(opacity)
                            .animation(.default.delay(Double(results.index) * 0.2), value: opacity)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isShow = false
                        }
                        SEPlayer.shared.play(sound: .cancelSound)
                    }){
                        HStack {
                            Image(systemName: "xmark")
                            Text("Close")
                        }
                        .foregroundColor(Color.heavyRed)
                    }
                    .buttonStyle(CustomButton())
                    .frame(height: 50)
                    .onAppear{
                        opacity = 1
                    }
                    .padding(.bottom, geometry.size.height * 0.1)
                }.transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .transition(.opacity)
        .onAppear {
            model.showScores()
        }
    }
}

struct HighScoreView_Previews: PreviewProvider {
    @State static var isShow = true
    static var previews: some View {
        HighScoreView(isShow: $isShow)
    }
}

class HighScoreViewModel: ObservableObject {
    @Published var results: [ResultModel] = []
    private let saveData: DataClass
    
    init(saveData: DataClass = SaveData.shared) {
        self.saveData = saveData
    }
    
    private func setResultScores() {
        for (index, type) in ResultValue.allCases.enumerated() {
            let loadScore = saveData.loadData(name: type)
            results.append(ResultModel(type: type, value: loadScore, index: index))
        }
    }
    
    func showScores() {
        setResultScores()
        results.indices.forEach { index in
            withAnimation(.linear(duration: 0.1).delay(10 + Double(index) * 0.3)){
                results[index].viewStatus = .onAppear
            }
            withAnimation(.linear(duration: 0.2).delay(10 + Double(index) * 0.3 + 0.1)){
                results[index].viewStatus = .isOn
            }
        }
    }
}
