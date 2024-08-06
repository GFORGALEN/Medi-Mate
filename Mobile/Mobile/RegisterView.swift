//
//  RegisterView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 50)
            
            VStack(spacing: 15) {
                CustomTextField(placeholder: "Username", text: $username)
                CustomTextField(placeholder: "Email", text: $email)
                CustomSecureField(placeholder: "Password", text: $password)
                CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)
            }
            .padding(.horizontal, 32)
            .padding()
            
            
            Button(action: registerAction) {
                Text("Register")
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.vertical)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    func registerAction() {
        print("Registration logic goes here.")
    }
}

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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
#Preview {
    RegisterView()
}
