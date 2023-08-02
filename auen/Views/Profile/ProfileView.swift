import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Profile")
                .foregroundColor(Color.black)
                .font(.system(size: 20, weight: .semibold))
                .padding(.top)
            if let currentUser = authViewModel.currentUser {
                Text("Email: \(currentUser.email)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
            }
            
            HStack {
                
                Button(action: {
                    authViewModel.signOut()
                }) {
                    HStack{
                        ZStack{
                           Image(systemName: "arrow.backward.square.fill")
                                .frame(width: 170, height: 170)
                                .foregroundColor(.red)
                        }
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.black)
                           
                    }
                }
            }
            .padding(.top, 20)
        }
        .onAppear {
            Task {
                await authViewModel.fetchUser()
            }
        }
    }
}
