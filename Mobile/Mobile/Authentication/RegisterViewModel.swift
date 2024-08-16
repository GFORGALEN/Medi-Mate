//
//  RegisterViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/7.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isRegistered = false
    
    private let apiService = UserAPIService.shared
    
    func resetRegistrationStatus() {
        isRegistered = false
    }
    
    func register() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let _: EmptyResponse = try await apiService.request(
                endpoint: "register",
                method: "POST",
                body: ["email": email, "password": password]
            )
            isRegistered = true
        } catch {
            if let apiError = error as? APIError, case .serverError(let message) = apiError {
                errorMessage = message
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
}

struct EmptyResponse: Codable {}
