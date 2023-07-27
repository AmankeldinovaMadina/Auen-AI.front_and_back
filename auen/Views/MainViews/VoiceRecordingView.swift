import SwiftUI

struct VoiceRecordingView: View {
    @StateObject var audioRecorder = AudioRecorderModel()
    @Binding var currentStage: ViewStage
  
    
    var body: some View {
        VStack{
            ZStack{
                Image("music_notes")
                    .resizable()
                    .frame(width: 1126, height: 675)
                    .offset(y:-460)
                VStack{
                    RecordTextView()
                    RecordButtonView(audioRecorder: audioRecorder, currentStage: $currentStage)
                        .padding(.top)
                }
            }
        }
    }
}




struct RecordTextView: View {
    var body: some View {
        VStack{
        Text("Tap to record")
            .font(.system(size: 28, weight: .semibold))
        Text("record melody that you created here")
            .font(.system(size: 17))
            .padding(.top, 8)
    } .foregroundColor(.black)
}
}


struct RecordButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var audioRecorder: AudioRecorderModel
    @State private var isPressed = false
    @Binding var currentStage: ViewStage
   
    var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 0.5)
            .onChanged { _ in
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                    isPressed = true
                }
                
                audioRecorder.startRecording()
            }
            .onEnded { _ in
                withAnimation(.easeInOut) {
                    isPressed = false
                }
                
                audioRecorder.stopRecording()
                currentStage = .loading
              
            }
            
        return ZStack {
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 282, height: 282)
                .opacity(0.4)
                .scaleEffect(isPressed ? 1.2 : 1.0)
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 223, height: 223)
                .opacity(0.6)
                .scaleEffect(isPressed ? 1.2 : 1.0)
            
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 180, height: 180)
        }
        .gesture(longPressGesture)
    }
}
