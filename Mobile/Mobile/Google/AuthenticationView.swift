import Foundation
import FirebaseCore
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

class AuthenticationView: ObservableObject {
    @Published var isLoginSuccessed = false
    @Published var currentUser: User?
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    @Published var userPicURL: URL?
    @Published var userId: String = ""
    @Published var errorMessage: String?
    
    private let apiService = UserAPIService.shared

    init() {
        self.currentUser = Auth.auth().currentUser
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = "Google Sign-In error: \(error.localizedDescription)"
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken else {
                self?.errorMessage = "Failed to get user information from Google Sign-In"
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            
            self?.authenticateWithFirebase(credential: credential, user: user)
        }
    }
    
    private func authenticateWithFirebase(credential: AuthCredential, user: GIDGoogleUser) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Firebase authentication failed: \(error.localizedDescription)"
                return
            }
            
            self?.currentUser = authResult?.user
            self?.isLoginSuccessed = true
            
            self?.updateUserInfo(user: user)
            self?.storeUserInDatabase(user: user)
        }
    }
    
    private func updateUserInfo(user: GIDGoogleUser) {
        self.userEmail = user.profile?.email ?? ""
        self.userName = user.profile?.name ?? ""
        self.userPicURL = user.profile?.imageURL(withDimension: 200)
        self.userId = user.userID ?? ""
    }
    
    private func storeUserInDatabase(user: GIDGoogleUser) {
        guard let email = user.profile?.email,
              let googleId = user.userID,
              let username = user.profile?.name,
              let userPic = user.profile?.imageURL(withDimension: 200)?.absoluteString else {
            self.errorMessage = "Failed to get complete user information"
            return
        }
        
        Task {
            do {
                let _: GoogleLoginResponse = try await apiService.request(
                    endpoint: "google-login",
                    method: "POST",
                    body: [
                        "email": email,
                        "googleId": googleId,
                        "username": username,
                        "userPic": userPic
                    ]
                )
                await MainActor.run {
                    print("User successfully stored in database")
                    // Update user information if needed based on the response
                    // For example:
                    // self.userId = response.userId ?? self.userId
                }
            } catch {
                // Error handling code...
            }
        }
    }
    
    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
        isLoginSuccessed = false
        currentUser = nil
        // Clear user info
        userEmail = ""
        userName = ""
        userPicURL = nil
        userId = ""
        errorMessage = nil
    }
}

struct GoogleLoginResponse: Codable {
    let userId: String?
    let email: String?
    // Add other fields as needed based on your API response
}
