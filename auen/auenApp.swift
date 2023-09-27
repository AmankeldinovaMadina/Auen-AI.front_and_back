import SwiftUI
import Firebase
@main
struct auenApp: App {
//    @StateObject var viewModel = AuthViewModel()
    @StateObject var audioRecorder = AudioRecorderModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
//            if !OnboardingManager.isOnboardingCompleted {
//                OnboardingsController()
//                    .environmentObject(audioRecorder)
//            } else{
                ContentView()
                //                .environmentObject(viewModel)
                    .environmentObject(audioRecorder)
//            }
        }
    }
}


