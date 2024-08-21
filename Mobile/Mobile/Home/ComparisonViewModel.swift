//
//  ComparisonViewModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/21.
//

import Foundation

class ComparisonViewModel: ObservableObject {
    @Published var comparisons: [Comparison] = []
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchComparisons(productIds: [String]) async {
        do {
            let jsonString = try await networkService.compareProducts(productIds: productIds)
            let decodedData = try JSONDecoder().decode(APIResponse<ComparisonData>.self, from: Data(jsonString.utf8))
            
            DispatchQueue.main.async {
                self.comparisons = decodedData.data.comparisonRequest.comparisons
            }
        } catch {
            print("Error fetching comparison data: \(error)")
        }
    }
}

struct ComparisonData: Codable {
    let comparisonRequest: ComparisonRequest
}

struct ComparisonRequest: Codable {
    let comparisons: [Comparison]
}
