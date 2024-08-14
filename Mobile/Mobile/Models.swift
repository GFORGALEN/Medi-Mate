//
//  ProductModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/10.
//

import Foundation
import UIKit



// Mediction Model
struct Medication {
    let image: UIImage?
    let description: MedicationInfo?
}

struct MedicationInfo: Codable {
    let name: String
    let description: String
    let commonUse: String
    let sideEffects: String
}

struct SearchRequest: Codable {
    let page: Int
    let pageSize: Int
    let productName: String
    let manufacture: String
}

struct APIResponse: Codable {
    let code: Int
    let msg: String?
    let data: ResponseData
}

struct ResponseData: Codable {
    let text: String
}

struct Product: Codable, Identifiable{
    let id: String
    let name: String
    let imageURL: String
}

struct Product1: Codable, Identifiable {
    let commonUse: String?
    let directions: String?
    let generalInformation: String?
    let imageSrc: String
    let ingredients: String?
    let manufacturerName: String?
    let productId: String
    let productName: String
    let productPrice: String
    let warnings: String?
    
    var id: String { productId }
    
    var intProductId: Int? {
        return Int(productId)
    }
}
