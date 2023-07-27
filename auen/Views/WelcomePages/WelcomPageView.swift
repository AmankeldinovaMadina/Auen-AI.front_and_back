import SwiftUI

struct WelcomPageView: View {
    @State var registration = false
    @State var authorization = false
    var body: some View {
        NavigationView {
            VStack {
                Image("music_notes")
                    .resizable()
                    .frame(width: 923, height: 500)
                    .ignoresSafeArea()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                WelcomeTextView()
                NavigationLink(destination: RegistrationView()) {
                    SignUpButtonView()
                        .padding(.top, 23)
                }
                NavigationLink(destination: AuthorizationView()) {
                    HaveAccButtonView()
                        .padding(.top)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .accentColor(.black)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}



struct SignUpButtonView: View {
    var body: some View {
            ZStack{
                Capsule()
                    .frame(height: 54)
                    .foregroundColor(Color.black)
                Text("Sign Up")
                    .foregroundColor(Color.white)
                    .font(.system(size: 17, weight: .semibold))
            }
    }
}

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

struct HaveAccButtonView: View {
    var body: some View{
            Text("I already have an account")
                .foregroundColor(Color.black)
                .font(.system(size: 17, weight: .semibold))
    }
}

struct WelcomPage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomPageView()
    }
}

