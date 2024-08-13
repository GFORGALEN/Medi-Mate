//
//  SearchViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/9.
//

import Foundation
import UIKit

struct MedicationInfo: Codable {
    let name: String
    let description: String
    let commonUse: String
    let sideEffects: String
}

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResult: String = ""
    @Published var isFinished = false
    @Published var image: UIImage = UIImage(systemName: "star") ?? UIImage()
    @Published var isLoading = false
    @Published var medicationInfo: MedicationInfo?

    func uploadImage(_ image: UIImage) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        do {
            let compressedImage = compressImage(image)
            let result = try await imageSearch(image: compressedImage)
            DispatchQueue.main.async {
                self.searchResult = result
                self.parseSearchResult()
                self.isLoading = false
                self.isFinished = true
            }
        } catch {
            DispatchQueue.main.async {
                self.searchResult = "Error: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
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

// 用于解析 API 响应的结构体
struct APIResponse: Codable {
    let code: Int
    let msg: String?
    let data: ResponseData
}

struct ResponseData: Codable {
    let text: String
}


