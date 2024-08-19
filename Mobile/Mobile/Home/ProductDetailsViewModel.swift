//
//  ProductDetailsViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI


class ProductDetailsViewModel: ObservableObject {
    @Published var productDetails: ProductDetails?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkService: NetworkServiceProtocol
    private let productId: String
    
    init(productId: String, networkService: NetworkServiceProtocol = NetworkService()) {
        self.productId = productId
        self.networkService = networkService
    }
    
    func loadProductDetails() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let jsonString = try await networkService.fetchProductDetails(productId: productId)
                let details = try parseProductDetails(from: jsonString)
                DispatchQueue.main.async {
                    self.productDetails = details
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    private func parseProductDetails(from jsonString: String) throws -> ProductDetails {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        
        let decoder = JSONDecoder()
        
        // Define a structure to match the JSON response
        struct Response: Codable {
            let code: Int
            let msg: String?
            let data: ProductDetails
        }
        
        let response = try decoder.decode(Response.self, from: jsonData)
        
        // You might want to check the response code here
        guard response.code == 1 else {
            throw NSError(domain: "APIError", code: response.code, userInfo: [NSLocalizedDescriptionKey: response.msg ?? "Unknown error"])
        }
        
        return response.data
    }
}

