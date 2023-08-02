import SwiftUI
import Firebase

struct AuthorizationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isUsernameFocused = false
    @State private var isPasswordFocused = false
    @State private var showErrorMessage = false
    @State private var errorMessage = ""
   
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("birdIconAuen")
                 .resizable()
                 .frame(width: 120, height: 120)
                 .aspectRatio(contentMode: .fill)
            TextField("Username", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: isUsernameFocused ? 1 : 0)
                        )
                )
                .onTapGesture {
                    isUsernameFocused = true
                    isPasswordFocused = false
                }
            
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: isPasswordFocused ? 1 : 0)
                        )
                )
                .onTapGesture {
                    isPasswordFocused = true
                    isUsernameFocused = false
                }
            
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.signIn(withEmail: email, password: password)
                    } catch let error {
                        showErrorMessage = true
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                SignInButton()
                    .padding(.top)
            }
            
            if showErrorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top)
            }
        }
        .padding()
        .alert(isPresented: $showErrorMessage) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
    }
}

struct SignInButton: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 54)
            
            Text("Sign In")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView()
    }
}
