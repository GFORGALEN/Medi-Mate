//
//  MediModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/16.
//

import UIKit



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

struct SearchResponse: Codable {
    let data: SearchData
}

struct SearchData: Codable {
    let records: [Product1]
    let total: Int
}

struct ProductDetails: Codable {
    let productId: String
    let productName: String
    let productPrice: String
    let manufacturerName: String
    let generalInformation: String
    let warnings: String
    let commonUse: String
    let ingredients: String
    let directions: String
    let imageSrc: String
    let summary: String
}
