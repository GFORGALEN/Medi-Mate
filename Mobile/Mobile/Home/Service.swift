//
//  Service.swift
//  Mobile
//
//  Created by Jabin on 2024/8/16.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func textSearch(page: Int, pageSize: Int, productName: String, manufacture: String) async throws -> String
    func imageSearch(image: UIImage) async throws -> String
    func fetchProductDetails(productId: String) async throws -> String
    func compareProducts(productIds: [String]) async throws -> String
    func findProduct(productId: String, pharmacyId: Int) async throws -> String

}

class NetworkService: NetworkServiceProtocol {
    func textSearch(page: Int, pageSize: Int, productName: String, manufacture: String) async throws -> String {
        var components = URLComponents(string: "\(Constant.apiSting)/api/products")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "productName", value: productName),
            URLQueryItem(name: "manufacture", value: manufacture)
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func imageSearch(image: UIImage) async throws -> String {
        guard let url = URL(string: "\(Constant.apiSting)/api/message/image") else {
            throw URLError(.badURL)
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            data.append(imageData)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        let (imageData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        
        return String(data: imageData, encoding: .utf8) ?? ""
    }
    
    func fetchProductDetails(productId: String) async throws -> String {
        guard var urlComponents = URLComponents(string: "\(Constant.apiSting)/api/products/productDetail") else {
                throw URLError(.badURL)
            }
            
            urlComponents.queryItems = [URLQueryItem(name: "productId", value: productId)]
            
            guard let url = urlComponents.url else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            return String(data: data, encoding: .utf8) ?? ""
        }
    
    func compareProducts(productIds: [String]) async throws -> String {
            guard let url = URL(string: "\(Constant.apiSting)/api/message/comparison") else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
            
            let body = ["productId": productIds]
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            return String(data: data, encoding: .utf8) ?? ""
        }
    func findProduct(productId: String, pharmacyId: Int) async throws -> String {
            guard let url = URL(string: "\(Constant.apiSting)/api/products/productLocation") else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = LocationRequest(productId: productId, pharmacyId: pharmacyId)
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            
            return String(data: data, encoding: .utf8) ?? ""
        }
}
