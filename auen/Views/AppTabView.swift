import SwiftUI

struct AppTabView: View {
    @EnvironmentObject var audioRecorder: AudioRecorderModel
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
        } .accentColor(Color(red: 0.91, green: 0.11, blue: 0.45))
    }
}

