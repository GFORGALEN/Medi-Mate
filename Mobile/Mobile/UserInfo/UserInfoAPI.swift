//
//  UserInfoAPI.swift
//  Mobile
//
//  Created by Lykheang Taing on 09/09/2024.
//

import Foundation
import Foundation

class UserInfoAPI {
    static let shared = UserInfoAPI()
    private let baseURL = "http://52.64.142.47:8080/api"
    
    private init() {}
    
    func updateUserInfo(userInfo: UserInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "\(baseURL)/userinfo/updateUserInfo"
        performRequest(endpoint: endpoint, method: "PUT", body: userInfo, completion: completion)
    }
    
    func updatePassword(passwordUpdate: PasswordUpdate, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "\(baseURL)/user/updatePassword"
        performRequest(endpoint: endpoint, method: "PATCH", body: passwordUpdate, completion: completion)
    }
    
    private func performRequest<T: Encodable>(endpoint: String, method: String, body: T, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error: \(httpResponse.statusCode)"])))
                }
            }
        }.resume()
    }
}
