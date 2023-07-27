import SwiftUI
import AVFoundation
import AVKit


struct WavesView: View {
    @StateObject private var audioVM: AudioPlayViewModel
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 140) / 2 // between 0.1 and 35
        return CGFloat(level * (40/35))
    }
    
    init(audio: String) {
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: URL(string: audio)!, sampels_count: Int(UIScreen.main.bounds.width * 0.6 / 5)))
    }
    
    var body: some View {
        VStack {
            // Place the audio wave visualization at the top and increase its size
            HStack(alignment: .center, spacing: 7) {
                if audioVM.soundSamples.isEmpty {
                    ProgressView()
                } else {
                    ForEach(audioVM.soundSamples, id: \.self) { model in
                        BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                            .frame(height: 200) // Increase the height of the audio wave
                    }
                }
            }
            .frame(maxWidth: .infinity) // Expand the audio wave to fill the width
            
            // Place the button below the audio wave
            Button {
                if audioVM.isPlaying {
                    audioVM.pauseAudio()
                } else {
                    audioVM.playAudio()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.pink)
                    HStack {
                        Image(systemName: !(audioVM.isPlaying) ? "play.fill" : "pause.fill" )
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                        Text("Play")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(minHeight: 0, maxHeight: 50)
            
            
        }
        .padding(.top) // Add some top padding to separate from the top safe area
    }
}



struct BarView: View {
    let value: CGFloat
    var color: Color = .clear // Add a default color of clear

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color) // Use the specified color
                .frame(width: 4, height: value)
                .cornerRadius(10)
                .frame(width: 1, height: value)
        }
    }
}
