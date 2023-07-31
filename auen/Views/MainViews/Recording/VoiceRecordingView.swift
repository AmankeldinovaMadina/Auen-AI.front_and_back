import SwiftUI

struct VoiceRecordingView: View {
    @EnvironmentObject var audioRecorder:AudioRecorderModel
    @Binding var currentStage: ViewStage
    @State  var isPressed = false
    var body: some View {
        VStack{
            ZStack{
                Image("music_notes")
                    .resizable()
                    .frame(width: 1126, height: 675)
                    .offset(y:-460)
                ZStack{
                    VStack{
                        if audioRecorder.recording == false{
                            RecordTextView()
                        } else {
                            Text("")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        RecordButtonView(audioRecorder: _audioRecorder, isPressed: $isPressed, currentStage: $currentStage)
                    }
                    if audioRecorder.recording {
                        VStack{
                            Spacer()
                            RecordingVisualizing()
                                .padding(.bottom, 24)
                        }
                        
                    } else {
                        Text("")
                    }
                }
            }
        }
    }
}




struct RecordTextView: View {
    @State private var showFirstText = true
    @State private var showSecondText = false
    
    var body: some View {
        VStack {
            if showFirstText {
                HStack{
                    Image(systemName: "mic.fill")
                    Text("tap to record")
                        .font(.system(size: 18, weight: .semibold))
                        .opacity(showFirstText ? 1 : 0)
                        .animation(.easeInOut(duration: 1))
                }
            }
            if showSecondText {
                HStack{
                    Image(systemName: "mic.fill")
                    Text("record melody that you created here")
                        .font(.system(size: 18, weight: .semibold))
                        .opacity(showSecondText ? 1 : 0)
                        .animation(.easeInOut(duration: 1))
                }
            }
        }
        .foregroundColor(.black)
        .padding(.bottom)
        .onAppear {
            animateTexts()
        }
    }
    
    private func animateTexts() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            withAnimation {
                showFirstText.toggle()
                showSecondText.toggle()
            }
        }
    }
}




struct RecordButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var audioRecorder:AudioRecorderModel
    @Binding  var isPressed: Bool
    @Binding var currentStage: ViewStage
    
    var body: some View {
        let longPressGesture = LongPressGesture(minimumDuration: 0.5)
            .onChanged { _ in
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                    isPressed.toggle()
                }
                
                audioRecorder.startRecording()
            }
            .onEnded { _ in
                withAnimation(.easeInOut) {
                    
                }
                
                audioRecorder.stopRecording()
                currentStage = .loading
                
            }
        
        return ZStack {
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 210, height: 210)
                .opacity(0.2)
                .scaleEffect(isPressed ? 1.8 : 1.0)
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 205, height: 205)
                .opacity(0.4)
                .scaleEffect(isPressed ? 1.6 : 1.0)
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 200, height: 200)
                .opacity(0.6)
                .scaleEffect(isPressed ? 1.3 : 1.0)
            
            Image("music_key")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 180, height: 180)
            
        }
        .gesture(longPressGesture)
    }
}
