//
//  ProductModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/10.
//

import Foundation
import UIKit
import MapKit



// Mediction Model


struct ResponseData: Codable {
    let text: String
}

struct Product: Codable, Identifiable{
    let id: String
    let name: String
    let imageURL: String
}

struct Location: Identifiable, Codable {
    let id : Int
    let name_store: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LocationsData: Codable {
    let locations: [Location]
}


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


struct APIResponse<T: Codable>: Codable {
    let code: Int
    let msg: String?
    let data: T
}
