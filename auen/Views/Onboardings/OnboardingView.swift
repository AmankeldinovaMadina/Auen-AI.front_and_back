//import SwiftUI
//
//
//enum OnboardingPages{
//    case pageOne
//    case pageTwo
//    case welcomePage
//}
//
//struct OnboardingsController: View {
//    @State var activePage: OnboardingPages = .pageOne
//    @EnvironmentObject var audioRecorder: AudioRecorderModel
//    
//    var body: some View {
//        if activePage == .pageOne{
//            OnboardingMainView(activePage: $activePage)
//        } else if activePage == .pageTwo{
//           OnboardingView(activePage: $activePage)
//        } else {
//            ContentView(audioRecorder: _audioRecorder)
//               
//        }
//    }
//}
//
//
//
//
//struct OnboardingView: View {
//    @Binding var activePage: OnboardingPages 
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Record & Convert")
//                .font(.system(size: 45, weight: .bold))
//                .foregroundColor(.black)
//            
//            Text("Record your voice or any acapella music and this app will convert your audio to the piano sound and give music notes of this melody.")
//                .multilineTextAlignment(.center)
//                .font(.body)
//                .foregroundColor(.gray)
//                .padding(.horizontal, 30)
//            ZStack{
//                Image("screen")
//                    .resizable()
//                    .frame(width: 250, height: 500)
//                    .aspectRatio(contentMode: .fit)
//                    .offset(x:-100)
//                Image("converted")
//                    .resizable()
//                    .frame(width: 250, height: 500)
//                    .aspectRatio(contentMode: .fit)
//                    .offset(x:50)
//                Image("noteView")
//                    .resizable()
//                    .frame(width: 250, height: 500)
//                    .aspectRatio(contentMode: .fit)
//                    .offset(x:150)
//            }
//           CustomButtonNextView(activePage: $activePage)
//                .padding(.bottom)
//        }
//        .padding(.top, 50)
//        .navigationBarHidden(true)
//    }
//}
//
//
