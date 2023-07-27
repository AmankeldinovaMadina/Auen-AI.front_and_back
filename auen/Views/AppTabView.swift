import SwiftUI

struct AppTabView: View {
    @StateObject var audioRecorder = AudioRecorderModel()
    @EnvironmentObject var viewModel: AuthViewModel
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = .black
    }
    
    var body: some View {
        TabView {
            ConvertingView()
                .tabItem {
                    Label("Converting", systemImage: "music.note.list")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

