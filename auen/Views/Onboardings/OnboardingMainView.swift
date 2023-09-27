//import SwiftUI
//
//struct OnboardingMainView: View {
////    @Binding var activePage: OnboardingPages
//    var body: some View {
//        VStack() {
//            Image("bird")
//                .resizable()
//                .frame(width: 150, height: 150)
//                .aspectRatio(contentMode: .fit)
//                .padding(.top, 150)
//            Text("Auen-AI")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.black)
//                .padding(.top, 20)
//
//            Text("Welcome to Auen-AI, an application designed to transform your voice and acapella recordings into beautiful piano melodies.")
//                .multilineTextAlignment(.center)
//                .font(.body)
//                .foregroundColor(.gray)
//                .padding(.horizontal, 30)
//            Spacer()
//            CustomButtonNextView()
//        }
//        .padding(.top, 50)
//        .navigationBarHidden(true)
//    }
//}
//
//struct AuthorizationView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingMainView()
//    }
//}
//
//
//struct NextButtonView: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 90)
//                .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
//                .frame(height: 54)
//                .padding(.horizontal)
//            
//            Text("Next")
//                .foregroundColor(.white)
//                .font(.system(size: 17, weight: .semibold))
//        }
//        .padding(.top)
//    }
//}
