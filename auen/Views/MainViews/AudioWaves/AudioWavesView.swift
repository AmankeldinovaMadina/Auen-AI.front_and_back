import SwiftUI
import AVFoundation
import AVKit


struct WavesView: View {
    @StateObject private var audioVM: AudioPlayViewModel
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 140) / 2
        return CGFloat(level * (40/35))
    }
    
    init(audio: String) {
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: URL(string: audio)!, sampels_count: Int(UIScreen.main.bounds.width * 0.6 / 5.5)))
    }
    
    var body: some View {
        VStack {
           
            HStack(alignment: .center, spacing: 7) {
                if audioVM.soundSamples.isEmpty {
                    ProgressView()
                } else {
                    ForEach(audioVM.soundSamples, id: \.self) { model in
                        BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                            .frame(height: 200)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
         
            Button {
                if audioVM.isPlaying {
                    audioVM.pauseAudio()
                } else {
                    audioVM.playAudio()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 95, height: 54)
                    
                    HStack {
                        Image(systemName: !(audioVM.isPlaying) ? "play.fill" : "pause.fill" )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text("Play")
                    } .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .frame(minHeight: 0, maxHeight: 50)
            
            
        }
        .padding(.top)
    }
}



struct BarView: View {
    let value: CGFloat
    var color: Color = .clear

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color) 
                .frame(width: 4, height: value)
                .cornerRadius(10)
                .frame(width: 1, height: value)
        }
    }
}
