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
