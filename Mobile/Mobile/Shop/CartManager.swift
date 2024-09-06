//
//  CartManager.swift
//  Mobile
//
//  Created by Lykheang Taing on 06/09/2024.
//

import Foundation

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    
    func addToCart(_ product: ProductDetails) {
        if let index = items.firstIndex(where: { $0.product.productId == product.productId }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(_ product: ProductDetails) {
        items.removeAll { $0.product.productId == product.productId }
    }
    
    func updateQuantity(for product: ProductDetails, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.productId == product.productId }) {
            items[index].quantity = max(0, quantity)
            if items[index].quantity == 0 {
                items.remove(at: index)
            }
        }
    }
    
    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + (Double($1.product.productPrice) ?? 0) * Double($1.quantity) }
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: ProductDetails
    var quantity: Int
}
