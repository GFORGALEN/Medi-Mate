//
//  ProductDetailsViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI


@MainActor
class ProductDetailsViewModel: ObservableObject {
    @Published private(set) var state: LoadingState = .idle
    
    private let networkService: NetworkServiceProtocol
    private let productId: String
    
    init(productId: String, networkService: NetworkServiceProtocol = NetworkService()) {
        self.productId = productId
        self.networkService = networkService
    }
    
    func loadProductDetails() async {
        state = .loading
        
        do {
            let jsonString = try await networkService.fetchProductDetails(productId: productId)
            let details = try parseProductDetails(from: jsonString)
            state = .loaded(details)
        } catch {
            state = .error(error)
        }
    }
    
    private func parseProductDetails(from jsonString: String) throws -> ProductDetails {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(APIResponse<ProductDetails>.self, from: jsonData)
        
        guard response.code == 1 else {
            throw NSError(domain: "APIError", code: response.code, userInfo: [NSLocalizedDescriptionKey: response.msg ?? "Unknown error"])
        }
        
        return response.data
    }
    
    enum LoadingState {
        case idle
        case loading
        case loaded(ProductDetails)
        case error(Error)
    }
}
