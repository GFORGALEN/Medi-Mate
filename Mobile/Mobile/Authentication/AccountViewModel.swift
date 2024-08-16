//
//  AccountViewModel.swift
//  Mobile
//
//  Created by Lykheang Taing on 16/08/2024.
//

import Foundation
import Foundation
import SwiftUI

class AccountViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    @Published var updatePasswordError: String?
    @Published var isUpdatingPassword = false
    
    private let apiService = UserAPIService.shared
    
    func updatePassword(email: String) async {
        guard !oldPassword.isEmpty, !newPassword.isEmpty, !confirmNewPassword.isEmpty else {
            updatePasswordError = "All fields are required"
            return
        }
        
        guard newPassword == confirmNewPassword else {
            updatePasswordError = "New passwords do not match"
            return
        }
        
        isUpdatingPassword = true
        updatePasswordError = nil
        
        do {
            let response: UpdatePasswordResponse = try await apiService.request(
                endpoint: "updatePassword",
                method: "POST",
                body: [
                    "email": email,
                    "oldPassword": oldPassword,
                    "newPassword": newPassword
                ]
            )
            
            await MainActor.run {
                if response.code == 1 { // Assuming code 1 means success
                    // Password updated successfully
                    oldPassword = ""
                    newPassword = ""
                    confirmNewPassword = ""
                    updatePasswordError = nil
                } else {
                    updatePasswordError = response.msg ?? "Failed to update password"
                }
            }
        } catch {
            await MainActor.run {
                if let apiError = error as? APIError {
                    updatePasswordError = apiError.description
                } else {
                    updatePasswordError = "An unexpected error occurred: \(error.localizedDescription)"
                }
            }
        }
        
        isUpdatingPassword = false
    }
}

struct UpdatePasswordResponse: Codable {
    let code: Int
    let msg: String?
}


