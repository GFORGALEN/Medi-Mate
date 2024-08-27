//
//  ChangePassWordView.swift
//  Mobile
//
//  Created by Lykheang Taing on 28/08/2024.
//

import Foundation
import Foundation
import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthenticationView
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    var body: some View {
        Form {
            Section(header: Text("Change Password")) {
                SecureField("Old Password", text: $oldPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmNewPassword)
            }
            
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if let success = successMessage {
                Text(success)
                    .foregroundColor(.green)
            }
            
            Button("Update Password") {
                updatePassword()
            }
            .disabled(oldPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty || newPassword != confirmNewPassword)
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func updatePassword() {
        guard let url = URL(string: "http://52.64.142.47:8080/api/user/updatePassword") else {
            errorMessage = "Invalid URL"
            return
        }
        
        let passwordUpdate = PasswordUpdate(
            email: authViewModel.userEmail,
            oldPassword: oldPassword,
            newPassword: newPassword
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authViewModel.token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(passwordUpdate)
        } catch {
            errorMessage = "Error encoding data: \(error.localizedDescription)"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    successMessage = "Password updated successfully"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    errorMessage = "Server error: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}

struct PasswordUpdate: Codable {
    let email: String
    let oldPassword: String
    let newPassword: String
}
