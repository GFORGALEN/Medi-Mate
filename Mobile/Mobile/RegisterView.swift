//
//  RegisterView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
        
    private var showSuccessAlert: Binding<Bool> {
            Binding(
                get: { viewModel.isRegistered },
                set: { _ in viewModel.resetRegistrationStatus() }
            )
        }

    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 50)
            
            VStack(spacing: 15) {
                CustomTextField(placeholder: "Username", text: $viewModel.username)
                CustomTextField(placeholder: "Email", text: $viewModel.email)
                CustomSecureField(placeholder: "Password", text: $viewModel.password)
                CustomSecureField(placeholder: "Confirm Password", text: $viewModel.confirmPassword)
            }
            .padding(.horizontal, 32)
            .padding()
            
            Button {
                Task {
                    await viewModel.register()
                }
            } label: {
                Text("Register")
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.vertical)
            .padding(.horizontal, 32)
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        
        .alert("Registration Successful", isPresented: showSuccessAlert) {
                    Button("OK") {}
                }
    }
}

// CustomTextField 和 CustomSecureField 保持不变

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { Text(placeholder).foregroundStyle(Color.gray).padding(.leading, 10) }
            TextField("", text: $text)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { Text(placeholder).foregroundStyle(Color.gray).padding(.leading, 10) }
            SecureField("", text: $text)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}


#Preview {
    RegisterView()
}
