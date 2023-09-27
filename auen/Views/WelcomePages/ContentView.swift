
import SwiftUI

struct ContentView: View {
    @State var converting = false
    @EnvironmentObject var audioRecorder: AudioRecorderModel
    
    var body: some View{
       
            
            if converting {
                ConvertingView()
            } else {
                WelcomPageView(converting: $converting)
            }
        
    }
}
