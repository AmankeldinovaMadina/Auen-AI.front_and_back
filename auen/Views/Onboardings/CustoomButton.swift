//import SwiftUI
//
//struct CustomButtonNextView: View {
////    @Binding var activePage: OnboardingPages
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Spacer()
//            CirclesView()
////            Button(action: {
////                switch activePage {
////                case .pageOne:
////                    activePage = .pageTwo
////                case .pageTwo:
////                    activePage = .welcomePage
////                    OnboardingManager.setOnboardingCompleted()
////                case .welcomePage:
////                    activePage = .welcomePage
////                    OnboardingManager.setOnboardingCompleted()
//                }
//            }) {
//                NextButtonView()
//            }
//            Spacer()
//        }
//    }
//}
//
//
//struct CirclesView: View {
////    @Binding var activePage: OnboardingPages
//
//    var body: some View {
//        HStack(spacing: 24) {
//            Circle()
//                .frame(width: 8)
////                .foregroundColor(activePage == .pageOne ? .black : Color(red: 0, green: 0, blue: 0, opacity: 0.4))
//            Circle()
//                .frame(width: 8)
//                .foregroundColor(activePage == .pageTwo ? .black : Color(red: 0, green: 0, blue: 0, opacity: 0.4))
//        }
//        .padding(.top, 32)
//    }
//}
//
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
