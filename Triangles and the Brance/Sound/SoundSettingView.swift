//
//  SoundSettingView.swift
//  Triangles and the Brance
//
//  Created by 森本拓未 on 2022/12/03.
//

import SwiftUI

struct SoundSettingView: View {
    @ObservedObject var bgmPlayer = BGMPlayer.shared
    @ObservedObject var soundPlayer = SEPlayer.shared
    @Binding var isShow: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Setting")
                    .font(.largeTitle)
                    .padding(.vertical)
                    .background {
                        Rectangle()
                            .frame(width: geometry.size.width)
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                HStack {
                    Text("BGM")
                        .frame(width: geometry.size.width * 0.1)
                    Button(action: {
                        bgmPlayer.muted.toggle()
                        bgmPlayer.setVolume()
                    },
                           label: {
                        Image(systemName: bgmPlayer.muted ? "speaker.slash" : "speaker.wave.2")
                            .resizable()
                            .scaledToFit()
                        .frame(width: geometry.size.width * 0.1)
                    })
                    
                    Slider(value: $bgmPlayer.volumeScale, in: 0...1, step: 0.1) { volume in
                        bgmPlayer.setVolume()
                    }
                        .padding()
                }
                .padding()
                HStack {
                    Text("SE")
                        .frame(width: geometry.size.width * 0.1)
                    Button(action: {
                        soundPlayer.muted.toggle()
                        soundPlayer.setVolume()
                    },
                           label: {
                        Image(systemName: soundPlayer.muted ? "speaker.slash" : "speaker.wave.2")
                            .resizable()
                            .scaledToFit()
                        .frame(width: geometry.size.width * 0.1)
                    })
                    Slider(value: $soundPlayer.volumeScale, in: 0...1, step: 0.1) { volume in
                        soundPlayer.setVolume()
                    }
                        .padding()
                }
                .padding()
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
                .padding(.bottom, geometry.size.height * 0.1)
            }
        }
        .tint(.heavyRed)
        .transition(.opacity)
    }
}

struct SoundSettingView_Previews: PreviewProvider {
    @State static var isShow = true
    static var previews: some View {
        SoundSettingView(isShow: $isShow)
    }
}

class SoundSettingViewModel: ObservableObject {
    
}
