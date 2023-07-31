import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var repeatedPassword = ""
    @State private var selectedField: Field = .none
    @State private var tabViewShowed = false
    @EnvironmentObject var viewModel : AuthViewModel
    enum Field {
        case username
        case password
        case repeatedPassword
        case none
    }
    
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
                                .stroke(selectedField == .username ? Color.black : Color.clear, lineWidth: 1)
                        )
                )
                .onTapGesture {
                    selectedField = .username
                }
            
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(selectedField == .password ? Color.black : Color.clear, lineWidth: 1)
                        )
                )
                .onTapGesture {
                    selectedField = .password
                }
            
            SecureField("Repeat password", text: $repeatedPassword)
                .autocapitalization(.none)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(selectedField == .repeatedPassword ? Color.black : Color.clear, lineWidth: 1)
                        )
                )
                .onTapGesture {
                    selectedField = .repeatedPassword
                }
            
           
            Button {
                Task{
                    try await viewModel.createUser(withEmail: email, password: password)
                    tabViewShowed = true
                }
            } label: {
                RegistrationSignUpButton()
                    .padding(.top)
            } .fullScreenCover(isPresented: $tabViewShowed) {
                AppTabView()
            }
        }
        .padding()
        
    }
}

struct RegistrationSignUpButton: View {
    var body: some View {
            ZStack {
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 54)
                
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .semibold))
            }
    }
}



struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
