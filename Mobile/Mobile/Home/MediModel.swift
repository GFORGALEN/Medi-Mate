//
//  MediModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/16.
//

import UIKit

struct Medicine: Codable, Identifiable {
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
    let records: [Medicine]
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
