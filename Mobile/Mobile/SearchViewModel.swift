//
//  SearchViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/9.
//

import Foundation
import UIKit

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResult: String = ""
    @Published var image: UIImage = UIImage(systemName: "star") ?? UIImage()

    func search() async {
        do {
            let result = try await textSearch(searchText: searchText)

            DispatchQueue.main.async {
                self.searchResult = result
            }
        } catch {
            DispatchQueue.main.async {
                self.searchResult = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    private func textSearch(searchText: String) async throws -> String {
        guard let url = URL(string: "\(Constant.apiSting)/api/message/text") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["message": searchText])
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 解析 JSON 响应
        let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        // 返回 data 中的 text 内容
        return jsonResponse.data.text
    }
    
    func uploadImage(_ image: UIImage) async {
            do {
                let result = try await imageSearch(image: image)
                DispatchQueue.main.async {
                    self.searchResult = result
                }
            } catch {
                DispatchQueue.main.async {
                    self.searchResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    
    private func imageSearch(image: UIImage) async throws -> String {
            guard let url = URL(string: "\(Constant.apiSting)/api/message/image") else {
                throw URLError(.badURL)
            }
            //guard let ... else: 用于确保 URL 是有效的，如果 URL 构建失败，则抛出 URLError(.badURL) 错误

            // 生成边界字符串
            let boundary = UUID().uuidString

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            // 创建 multipart form data
            var data = Data()
            //创建一个空的 Data 对象，用于存储请求体的二进制数据
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                data.append(imageData)
            }
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            // 设置请求体
            request.httpBody = data
            //将构建好的 multipart/form-data 数据赋值给请求的 httpBody 属性

            let (responseData, _) = try await URLSession.shared.data(for: request)
            //使用共享的 URLSession 实例发送 POST 请求，并等待返回的数据。这个调用是异步的，因此需要使用 await

            // 解析 JSON 响应
            let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: responseData)

            // 返回 data 中的 text 内容
            return jsonResponse.data.text
        }
    
    
    
    
    
    
    
}

// 用于解析 API 响应的结构体
struct APIResponse: Codable {
    let code: Int
    let msg: String?
    let data: ResponseData
}

struct ResponseData: Codable {
    let text: String
}


