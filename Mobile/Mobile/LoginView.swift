import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var showRegister = false // Register page
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome to Medimate")
                    .font(.title)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                
                Button/*(action: login)*/ {
                }
            label:{
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 1, y: 5)
                }
                
                Button {
                    AuthenticationView().signInWithGoogle()
                } label: {
                    HStack {
                        Text("Sign in with Google")
                            .foregroundColor(.black)
                            .bold()
                    }
                    .frame(width: 250, height: 50)
                    .background(Color.white)
                    .cornerRadius(8)
                }
                .padding()
                .shadow(radius: 2)
                
                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button {
                    showRegister.toggle()
                } label: {
                    Text("Not have an account? Register")
                        .bold()
                        .foregroundColor(.black)
                }
                .padding(.top)
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
    
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()  // Use constant for preview
    }
}
