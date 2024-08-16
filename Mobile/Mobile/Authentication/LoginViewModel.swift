import Foundation
import SwiftUI

// Updated to match the actual API response structure
struct LoginResponse: Codable {
    let code: Int
    let msg: String?
    let data: UserData
}

struct UserData: Codable {
    let userId: String
    let username: String
    let email: String
    let userPic: String?
    let token: String
}

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var loginError = ""
    @Published var isLoading = false
    
    @Published var userId: String = ""
    @Published var username: String = ""
    @Published var userEmail: String = ""
    @Published var userPic: String = ""
    @Published var token: String = ""
        
    private let apiService = UserAPIService.shared
    
    func login(authViewModel: AuthenticationView) async {
        guard !email.isEmpty, !password.isEmpty else {
            loginError = "Email and password are required"
            return
        }
        
        isLoading = true
        loginError = ""
        
        do {
            let response: LoginResponse = try await apiService.request(
                endpoint: "login",
                method: "POST",
                body: ["email": email, "password": password]
            )
            
            await MainActor.run {
                if response.code == 1 { // Assuming code 1 means success
                    // Store response data
                    self.userId = response.data.userId
                    self.username = response.data.username
                    self.userEmail = response.data.email
                    self.userPic = response.data.userPic ?? ""
                    self.token = response.data.token
                    
                    // Update AuthenticationView properties
                    authViewModel.isLoginSuccessed = true
                    authViewModel.userEmail = self.userEmail
                    authViewModel.userName = self.username
                    authViewModel.userPicURL = URL(string: self.userPic)
                    authViewModel.userId = self.userId
                    
                    // Print response data to console
                    self.printLoginResponse()
                } else {
                    // Handle case where login was not successful
                    loginError = response.msg ?? "Login failed for unknown reason"
                    print("Login Error: \(loginError)")
                }
            }
        } catch {
            await MainActor.run {
                self.handleLoginError(error)
            }
        }
        
        isLoading = false
    }
    
    private func handleLoginError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let message):
                loginError = "Server error: \(message)"
            case .invalidResponse:
                loginError = "Invalid response from server"
            case .decodingError:
                loginError = "Error decoding server response"
            default:
                loginError = "An unexpected error occurred"
            }
        } else {
            loginError = "An unexpected error occurred: \(error.localizedDescription)"
        }
        print("Login Error: \(loginError)")
        print("Full error details: \(error)")
    }
    
    private func printLoginResponse() {
        let responseData = """
        Login Successful!
        User ID: \(userId)
        Username: \(username)
        Email: \(userEmail)
        User Picture URL: \(userPic)
        Token: \(token)
        """
        print(responseData)
    }
}
