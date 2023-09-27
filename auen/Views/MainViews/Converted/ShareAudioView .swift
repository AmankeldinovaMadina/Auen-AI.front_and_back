import AVKit
import SwiftUI

struct ShareAudioView: View {
    
    @EnvironmentObject var audioRecorderModel:AudioRecorderModel
    
    
    var body: some View {
        Menu {
            Button("Share Audio") {
                audioRecorderModel.shareAudio()
            }

        } label: {
                Label("", systemImage: "ellipsis.circle")
                .foregroundColor(.pink)
                .font(.system(size: 24))
            }
    }
}

