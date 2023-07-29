import SwiftUI


struct ConvertedSoundsView: View {
    @State private var showView = false
    @Binding var currentStage: ViewStage
    @EnvironmentObject var audioRecorderModel:AudioRecorderModel
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    currentStage = .voiceRecording
                } label: {
                    GenerateAgainButton()
                }
                Spacer()
            }
            HStack{
                Text("Piano")
                    .foregroundColor(.black)
                    .font(.system(size: 34, weight: .bold))
                    .padding(.all)
                
                Spacer()
            }
            Image("piano")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 165, height: 144)
                .padding(.top)
            WavesView(audio: audioRecorderModel.convertedFileURL!)
                .padding(.top, 25)
            Spacer()
            PDFShowView()
                .padding(.bottom)
        }
        
    }
    
}


struct GenerateAgainButton: View {
    var body: some View {
        HStack{
            Image(systemName: "chevron.backward")
                .padding(.leading, 16)
            Text("Recording")
                .padding(.top, 8)
                
        }.foregroundColor(.pink)
    }
}
