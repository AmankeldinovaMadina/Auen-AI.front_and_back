import SwiftUI

struct WelcomPageView: View {
//    @State var registration = false
//    @State var authorization = false
    @Binding var converting: Bool
    
    var body: some View {
//        NavigationView {
            ZStack{
                VStack{
                    Image("notes")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    Spacer()
                }
                VStack {
                    Spacer()
                    WelcomeTextView()
                    Button {
                        converting = true
                    } label: {
                        StartButton()
                    }

//                    NavigationLink(destination: AuthorizationView()) {
//                        HaveAccButtonView()
//                            .padding(.top)
//                            .padding(.bottom)
//                    }
                   
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
//        }
//        .accentColor(.black)
//        .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: $converting){
                ConvertingView()
            }
        
    }
}

struct StartButton: View {
    var body: some View {
            ZStack{
                Capsule()
                    .frame(height: 54)
                    .foregroundColor(Color.black)
                Text("Start")
                    .foregroundColor(Color.white)
                    .font(.system(size: 17, weight: .semibold))
            }
    }
}


//struct SignUpButtonView: View {
//    var body: some View {
//            ZStack{
//                Capsule()
//                    .frame(height: 54)
//                    .foregroundColor(Color.black)
//                Text("Sign Up")
//                    .foregroundColor(Color.white)
//                    .font(.system(size: 17, weight: .semibold))
//            }
//    }
//}

struct WelcomeTextView: View{
    var body: some View{
        Group {
            Text("Power of composition")
            Text("accessible to all")
        }
        .foregroundColor(Color.black)
        .font(.system(size: 28, weight: .semibold))
    }
}

//struct HaveAccButtonView: View {
//    var body: some View{
//            Text("I already have an account")
//                .foregroundColor(Color.black)
//                .font(.system(size: 17, weight: .semibold))
//    }
//}
//
