//import SwiftUI
//
//struct RegistrationView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var repeatedPassword = ""
//    @State private var selectedField: Field = .none
//    @State private var tabViewShowed = false
//    @State private var showErrorMessage = false
//    @State private var errorMessage = ""
////    @EnvironmentObject var viewModel : AuthViewModel
//    
//    enum Field {
//        case username
//        case password
//        case repeatedPassword
//        case none
//    }
//    
//    var body: some View {
//        
//        VStack {
//           Image("birdIconAuen")
//                .resizable()
//                .frame(width: 120, height: 120)
//                .aspectRatio(contentMode: .fill)
//            TextField("Email", text: $email)
//                .autocapitalization(.none)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 4)
//                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 4)
//                                .stroke(selectedField == .username ? Color.black : Color.clear, lineWidth: 1)
//                        )
//                )
//                .onTapGesture {
//                    selectedField = .username
//                }
//            
//            SecureField("Password", text: $password)
//                .autocapitalization(.none)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 4)
//                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 4)
//                                .stroke(selectedField == .password ? Color.black : Color.clear, lineWidth: 1)
//                        )
//                )
//                .onTapGesture {
//                    selectedField = .password
//                }
//            
//            SecureField("Repeat password", text: $repeatedPassword)
//                .autocapitalization(.none)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 4)
//                        .foregroundColor(Color(red: 0.965, green: 0.965, blue: 0.965))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 4)
//                                .stroke(selectedField == .repeatedPassword ? Color.black : Color.clear, lineWidth: 1)
//                        )
//                )
//                .onTapGesture {
//                    selectedField = .repeatedPassword
//                }
//            
//           
//            Button {
//                Task{
//                    do{
//                        try await viewModel.createUser(withEmail: email, password: password)
//                        tabViewShowed = true
//                    } catch let error {
//                        showErrorMessage = true
//                        errorMessage = error.localizedDescription
//                    }
//                }
//                
//        
//            } label: {
//                RegistrationSignUpButton()
//                    .padding(.top)
//            } .fullScreenCover(isPresented: $tabViewShowed) {
//                AppTabView()
//            }
//            
//            if showErrorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .padding(.top)
//            }
//        }
//        .padding()
//        .alert(isPresented: $showErrorMessage) {
//                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//                }
//        
//    }
//}
//
//struct RegistrationSignUpButton: View {
//    var body: some View {
//            ZStack {
//                Capsule()
//                    .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
//                    .frame(height: 54)
//                
//                Text("Sign Up")
//                    .foregroundColor(.white)
//                    .font(.system(size: 17, weight: .semibold))
//            }
//    }
//}
//
//
//
//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView()
//    }
//}
