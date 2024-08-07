//
//  RegisterViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/7.
//

import SwiftUI

@MainActor //确保所有 UI 更新都在主线程上执行
class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    
    //允许外部读取但不能修改某些属性
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isRegistered = false
    
    func resetRegistrationStatus() {
            isRegistered = false
        }
    
    func register() async {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
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
            let result = try await registerUser(username: username, email: email, password: password)
            print("cool")
            isRegistered = result
        } catch {
            print("coo2l")

            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func registerUser(username: String, email: String, password: String) async throws -> Bool {
        guard let url = URL(string: "\(Constant.apiSting)/api/user/register") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = RegisterParameters(username: username, email: email, password: password)
        request.httpBody = try JSONEncoder().encode(parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //data: 返回的原始数据 json JSON string: {"code":0,"msg":"{password=Password must be between 10 and 100 characters, email=Email should be valid.}","data":null}
        //response：URLResponse 的对象，通常在实际使用中会被转换成更具体的 HTTPURLResponse 类型。
        
        
        if let rawJSONString = String(data: data, encoding: .utf8) {
            print("Raw response JSON string: \(rawJSONString)")
        }
   
        
        
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        //print(httpResponse)
        
        let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
        return registerResponse.msg
    }
}

struct RegisterParameters: Codable {
    let username: String
    let email: String
    let password: String
}

struct RegisterResponse: Codable {
    let code: Int
    let msg: String?
    let data: String?
}
