//
//  EditProfileView.swift
//  Mobile
//
//  Created by Lykheang Taing on 28/08/2024.
//


import Foundation
import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthenticationView
    @Binding var userInfo: UserInfo?
    
    @State private var birthYear: String = ""
    @State private var userWeight: String = ""
    @State private var userHeight: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Birth Year", text: $birthYear)
                    .keyboardType(.numberPad)
                TextField("Weight (kg)", text: $userWeight)
                    .keyboardType(.decimalPad)
                TextField("Height (cm)", text: $userHeight)
                    .keyboardType(.decimalPad)
            }
            
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Save Changes") {
                updateProfile()
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
        .onAppear {
            if let userInfo = userInfo {
                birthYear = String(userInfo.birthYear)
                userWeight = String(userInfo.userWeight)
                userHeight = String(userInfo.userHeight)
            }
        }
    }
    
    private func updateProfile() {
        guard let url = URL(string: "http://52.64.142.47:8080/api/userinfo/updateUserInfo") else {
            errorMessage = "Invalid URL"
            return
        }
        
        guard let birthYearInt = Int(birthYear),
              let userWeightInt = Int(userWeight),
              let userHeightInt = Int(userHeight) else {
            errorMessage = "Invalid input. Please enter valid numbers."
            return
        }
        
        let updatedUserInfo = UserInfo(
            userId: authViewModel.userId,
            birthYear: birthYearInt,
            userWeight: userWeightInt,
            userHeight: userHeightInt
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authViewModel.token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(updatedUserInfo)
        } catch {
            errorMessage = "Error encoding data: \(error.localizedDescription)"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
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
                    userInfo = updatedUserInfo
                    presentationMode.wrappedValue.dismiss()
                } else {
                    errorMessage = "Server error: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
