import Foundation
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

    init() {
        self.currentUser = Auth.auth().currentUser
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            print(accessToken)
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            print(credential)
            
            Auth.auth().signIn(with: credential) { [weak self] res, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.currentUser = res?.user
                self?.isLoginSuccessed = true
                
                // Update user information
                self?.updateUserInfo(user: user)
                
                // Store user in your database
                self?.storeUserInDatabase(user: user)
            }
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
            print("Failed to get user information")
            return
        }
        
        let url = URL(string: "http://172.24.72.175:8080/api/user/google-login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "googleId": googleId,
            "username": username,
            "userPic": userPic
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error serializing user data: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error storing user in database: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from server")
                return
            }
            
            print("User successfully stored in database")
        }.resume()
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
    }
}
