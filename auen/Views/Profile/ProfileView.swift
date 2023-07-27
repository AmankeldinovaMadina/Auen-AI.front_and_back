import SwiftUI
import FirebaseFirestore


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isEditing = false
    @State private var editedEmail = ""

    var body: some View {
        VStack {
            if let currentUser = authViewModel.currentUser {
                if isEditing {
                    TextField("Email", text: $editedEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                } else {
                    Text("Email: \(currentUser.email)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                }
            }

            HStack {
                if isEditing {
                    Button(action: {
                        if let currentUser = authViewModel.currentUser {
                            authViewModel.currentUser?.email = editedEmail
                            
                            Task {
                                do {
                                    let encodedUser = try Firestore.Encoder().encode(currentUser)
                                    let userId = currentUser.id 
                                    try await Firestore.firestore().collection("users").document(userId).setData(encodedUser)
                                    print("User information updated in Firestore.")
                                } catch {
                                    print("Failed to update user information in Firestore: \(error.localizedDescription)")
                                }
                            }
                        }
                        isEditing = false
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    .padding(.trailing, 10)
                } else {
                    Button(action: {
                        isEditing = true
                        if let currentUser = authViewModel.currentUser {
                            editedEmail = currentUser.email
                        }
                    }) {
                        Text("Edit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 150, height: 50)
                            .background(Color.green)
                            .cornerRadius(25)
                    }
                    .padding(.trailing, 10)
                }

                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.red)
                        .cornerRadius(25)
                }
            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            Task {
                await authViewModel.fetchUser()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
