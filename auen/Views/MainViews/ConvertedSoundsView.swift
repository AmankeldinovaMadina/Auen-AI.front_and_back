import SwiftUI

struct Piano: View {
    var body: some View{
        VStack {
            ZStack {
                Capsule()
                    .frame(width: 400, height: 600)
                    .foregroundColor(.clear)
                RadialGradient(
                    gradient: Gradient(colors: [.customPurple, .white]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 380
                )
                .opacity(0.4)
                .mask(Capsule())
                Image("piano")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 350)
                    .scaleEffect(x: -1, y: 1)
            }
        }
    }
}

struct ConvertedSoundsView: View {
    @State private var showView = false
    @Binding var currentStage: ViewStage
    @EnvironmentObject var audioRecorderModel:AudioRecorderModel
    
    
    var body: some View {
        ZStack {
            Piano()
            VStack{
            
                WavesView(audio: audioRecorderModel.convertedFileURL!)
                    
                    PDFShowView()
                    Spacer()
                HStack {
                    VStack {
                        Button {
                            currentStage = .voiceRecording
                        } label: {
                            GenerateAgainButton()
                        }
                        Spacer()
                    }
                    Spacer()
                    
                }
                .padding(.trailing)
            }
            
        }
            
    }
}


struct GenerateAgainButton: View {
    var body: some View {
        Image(systemName: "chevron.backward")
            .foregroundColor(Color.black)
            .padding(.all, 16)
    }
}
