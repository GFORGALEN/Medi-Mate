//
//  LoginViewModel.swift
//  Mobile
//
//  Created by Lykheang Taing on 13/08/2024.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var loginError = ""
    @Published var isLoading = false
    
    
    
    func login(authViewModel: AuthenticationView) async {
        guard !email.isEmpty, !password.isEmpty else {
            loginError = "Email and password are required"
            return
        }
        
        isLoading = true
        loginError = ""
        
        do {
            let result = try await loginUser(email: email, password: password)
            if result {
                // Update AuthenticationView
                authViewModel.isLoginSuccessed = true
                authViewModel.userEmail = email
                // You might want to update other properties of AuthenticationView here
            }
        } catch {
            loginError = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func loginUser(email: String, password: String) async throws -> Bool {
        guard let url = URL(string: "\(Constant.apiSting)/api/user/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            // Successfully logged in
            // Here you might want to parse the response and store any returned token or user information
            return true
        } else {
            // Login failed
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let msg = jsonObject["msg"] as? String {
                throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])
            } else {
                throw URLError(.badServerResponse)
            }
        }
    }
}
