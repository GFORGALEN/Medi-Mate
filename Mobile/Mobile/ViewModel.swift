//
//  ViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/7.
//

import Foundation


import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    var registrationSuccess = PassthroughSubject<Bool, Never>()
    
    func registerAction() {
        print("1")
        guard password == confirmPassword else {
            // 处理密码不匹配的情况
            print("Passwords do not match")
            registrationSuccess.send(false)
            return
        }
        
        guard let url = URL(string: "\(Constants.apiSting)/api/register") else {
            print("Invalid URL")
            registrationSuccess.send(false)
            return
        }
        
        let parameters = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        let jsonData = try? JSONEncoder().encode(parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let data = data, error == nil else {
//                print("Network request failed: \(error!)")
//                self?.registrationSuccess.send(false)
//                return
//            }
//            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // 注册成功的处理
                print("User registered successfully.")
                self?.registrationSuccess.send(true)
            } else {
                // 处理错误的响应
                print("Failed to register user.")
                self?.registrationSuccess.send(false)
            }
        }.resume()
    }
}
