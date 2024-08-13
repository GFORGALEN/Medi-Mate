//
//  SearchViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/9.
//

import Foundation
import UIKit
@MainActor

enum SearchError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}



class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResult: String = ""
    @Published var isFinished = false
    @Published var image: UIImage = UIImage(systemName: "star") ?? UIImage()
    @Published var isLoading = false
    @Published var medicationInfo: MedicationInfo?
    
        
    
    func search() async {
        isLoading = true
        do {
            let result = try await textSearch(searchText: searchText)
            searchResult = result
            parseSearchResult()
        } catch {
            self.searchResult = "Error: \(error.localizedDescription)"
            print("Error: \(error.localizedDescription)")
        }
        isLoading = false
}

    private func textSearch(searchText: String) async throws -> String {
            guard let url = URL(string: "\(Constant.apiSting)/api/products") else {
                throw SearchError.invalidURL
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
            let searchRequest = SearchRequest(
                    page: 1,
                    pageSize: 1,
                    productName: searchText,
                    manufacture: ""
                )   

        
            request.httpBody = try JSONEncoder().encode(searchRequest)

            let (data, response) = try await URLSession.shared.data(for: request)
            print("data")

        
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw SearchError.invalidResponse
                }

            // 解析 JSON 响应
            let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: data)

            // 返回 data 中的 text 内容
        return jsonResponse.data.text
        }
    

    func uploadImage(_ image: UIImage) async {
        isLoading = true
                do {
                    let compressedImage = compressImage(image)
                    let result = try await imageSearch(image: compressedImage)
                    searchResult = result
                    parseSearchResult()
                } catch {
                    searchResult = "Error: \(error.localizedDescription)"
                }
                isLoading = false
                isFinished = true
}

    private func imageSearch(image: UIImage) async throws -> String {
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

        let (responseData, _) = try await URLSession.shared.data(for: request)
        let jsonResponse = try JSONDecoder().decode(APIResponse.self, from: responseData)
        return jsonResponse.data.text
    }

    private func parseSearchResult() {
        guard let jsonData = searchResult.data(using: .utf8) else {
            print("Failed to convert string to data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            self.medicationInfo = try decoder.decode(MedicationInfo.self, from: jsonData)
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }

    private func compressImage(_ image: UIImage, maxFileSize: Int = 1_048_576, maxDimension: CGFloat = 512) -> UIImage {
        
        let resizedImage = resizeImage(image, maxDimension: maxDimension)
//        let resizedSize = resizedImage.jpegData(compressionQuality: 1.0)?.count ?? 0
//        print("Resized image size: \(formatFileSize(resizedSize))")
        
        var compressionQuality: CGFloat = 1.0
        var imageData = resizedImage.jpegData(compressionQuality: compressionQuality) ?? Data()
        
        while imageData.count > maxFileSize && compressionQuality > 0.1 {
            compressionQuality -= 0.1
            imageData = resizedImage.jpegData(compressionQuality: compressionQuality) ?? Data()
        }
        
//        let finalSize = imageData.count
//        print("Final compressed image size: \(formatFileSize(finalSize))")
//        print("Final compression quality: \(compressionQuality)")
        
        return UIImage(data: imageData) ?? image
    }
    
//    private func formatFileSize(_ bytes: Int) -> String {
//            let formatter = ByteCountFormatter()
//            formatter.allowedUnits = [.useBytes, .useKB, .useMB]
//            formatter.countStyle = .file
//            return formatter.string(fromByteCount: Int64(bytes))
//        }

    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        let aspectRatio = size.width / size.height
        
        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: min(size.width, maxDimension), height: min(size.width, maxDimension) / aspectRatio)
        } else {
            newSize = CGSize(width: min(size.height, maxDimension) * aspectRatio, height: min(size.height, maxDimension))
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
