import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showDeleteConfirmationAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Profile")
                    .foregroundColor(Color.black)
                    .font(.system(size: 35, weight: .bold))
                    .padding(.top, 25)
                
                HStack {
                    if let currentUser = authViewModel.currentUser {
                        Text("\(currentUser.initials)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                            .background(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .leading, endPoint: .trailing))
                            .clipShape(Circle())
                        Text("Email: \(currentUser.email)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .padding(.leading)
                VStack {
                    Section {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            HStack {
                                
                                Image(systemName: "arrow.backward.square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                
                                Text("Sign Out")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        
                        Button(action: {
                            showDeleteConfirmationAlert = true
                        }) {
                            HStack {
                              
                                Image(systemName: "x.square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                                
                                Text("Delete account")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            } .padding(.bottom)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 25)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.horizontal)
                .padding(.top, 20)
                
                VStack {
                    Section {
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            HStack {
                                
                                Image(systemName: "hand.raised.square.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                
                                Text("Privicy policy")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        
                        Button(action: {
                            showDeleteConfirmationAlert = true
                        }) {
                            HStack {
                              
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                
                                Text("Tech support")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                        }
                        Button(action: {
                            showDeleteConfirmationAlert = true
                        }) {
                            HStack {
                              
                                Image(systemName: "list.bullet.rectangle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                
                                Text("Terms and conditions")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            } .padding(.bottom)
                        }
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 25)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.horizontal)
                .padding(.top, 20)
                Image("music_notes") 
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .offset(x:10, y:-50)
            }
            .onAppear {
                Task {
                    await authViewModel.fetchUser()
                }
            }
            .alert(isPresented: $showDeleteConfirmationAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete your account?"),
                    primaryButton: .destructive(Text("Yes"), action: {
                        authViewModel.deleteAccount()
                    }),
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
    }
}
