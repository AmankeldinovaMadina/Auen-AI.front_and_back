import SwiftUI

struct MusicLoadingView: View {
    
    let noteSize: CGSize = CGSize(width: 20, height: 30)
    let noteSpacing: CGFloat = 10

    @EnvironmentObject var audioRecorder: AudioRecorderModel
    @State private var isAnimating = false
    @State private var isFileConverted = false

    @Binding var currentStage: ViewStage
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack(spacing: noteSpacing) {
                    ForEach(0..<3) { index in
                        NoteView(index: index)
                            .frame(width: noteSize.width, height: noteSize.height)
                            .offset(y: isAnimating ? (index % 2 == 0 ? -10 : 10) : 0)
                            .animation(Animation.easeInOut(duration: 0.8).repeatForever())
                            .onAppear() {
                                isAnimating = true
                            }
                            
                    }
                }
               Text("This could take a while, \n around 1-2 min")
                    .foregroundColor(.black)
                    .font(.system(size: 12, weight: .thin))
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
            }
                .padding()
            }
        }
    
    private func didChangeFileConverted(value: Bool) {
        currentStage = .convertedAudio
    }
    }



struct NoteView: View {
    
    let gradientColors = [Color.purple, Color.pink]
    var index: Int
    
    var body: some View {
        Image(systemName: "music.note")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .overlay(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing)
                    .mask(Image(systemName: "music.note")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    )
            )
    }
}
