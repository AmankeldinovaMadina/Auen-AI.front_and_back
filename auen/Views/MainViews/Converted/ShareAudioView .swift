import AVKit
import SwiftUI

struct ShareAudioView: View {
    
    @EnvironmentObject var audioRecorderModel:AudioRecorderModel
    
    
    var body: some View {
        Menu {
            Button("Share Audio") {
                audioRecorderModel.shareAudio()
            }
            Button("Download audio") {
                audioRecorderModel.shareAudio()
            }

        } label: {
                Label("", systemImage: "ellipsis.circle")
                .foregroundColor(.pink)
            }
    }
}

