//
//  RegisterViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/7.
//

import SwiftUI

@MainActor //确保所有 UI 更新都在主线程上执行
class RegisterViewModel: ObservableObject {
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
//        let randomInt = Int.random(in: 100000...99999999)
        
//        email="111ss1@gmail.com"
//        password="\(randomInt)12\(randomInt)"
//        confirmPassword="\(randomInt)12\(randomInt)"
        
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
            let result = try await registerUser( email: email, password: password)
            isRegistered = result
            
        } catch CustomError.custom(let message) {
            errorMessage = message
        } catch {
            errorMessage = "unexpect"
        }
        
        isLoading = false
    }
    
    private func registerUser(email: String, password: String) async throws -> Bool {
        guard let url = URL(string: "\(Constant.apiSting)/api/user/register") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = RegisterParameters(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //data: 返回的原始数据 json JSON string: {"code":0,"msg":"{password=Password must be between 10 and 100 characters, email=Email should be valid.}","data":null}
        //response：URLResponse 的对象，通常在实际使用中会被转换成更具体的 HTTPURLResponse 类型。
            
        
        if let rawJSONString = String(data: data, encoding: .utf8) {
            print("Raw response JSON string: \(rawJSONString)")
            
        }
        
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // 如果状态码不是200，尝试解析JSON数据
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let msg = jsonObject["msg"] as? String {
                    // 如果可以解析msg字段，则抛出包含此信息的错误
                    throw CustomError.custom(message: "\(msg)")
                } else {
                    // 如果无法找到msg字段，抛出另一个错误
                    throw CustomError.custom(message: "Error: 'msg' field not found")
                }
            }
        return true
    }
    
}

struct RegisterParameters: Codable {
    let email: String
    let password: String
}


enum CustomError: Error {
    case custom(message: String)
}
