import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var audioRecorder: AudioRecorderModel
    
    var body: some View{
        Group{
            if viewModel.userSession != nil {
                AppTabView()
            } else {
               WelcomPageView()
            }
        }
    }
}


