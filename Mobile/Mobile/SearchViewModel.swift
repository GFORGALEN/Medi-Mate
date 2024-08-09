//
//  SearchViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/9.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResult: String = ""

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


