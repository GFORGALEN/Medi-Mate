//
//  CartManager.swift
//  Mobile
//
//  Created by Lykheang Taing on 06/09/2024.
//

import Foundation

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var selectedStore: Store?
    init() {
            // Subscribe to the logout notification
            NotificationCenter.default.addObserver(self, selector: #selector(clearCart), name: .userDidLogout, object: nil)
        }
    func addToCart(_ product: ProductDetails) {
        if let index = items.firstIndex(where: { $0.product.productId == product.productId }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
//    func removeFromCart(_ product: ProductDetails) {
//        items.removeAll { $0.product.productId == product.productId }
//    }
//    
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
    
    func removeFromCart(_ product: ProductDetails) {
            items.removeAll { $0.product.productId == product.productId }
            objectWillChange.send()
        }
    
    var totalPrice: String {
            items.reduce("0") { result, item in
                guard let price = Double(item.product.productPrice),
                      let total = Double(result) else {
                    return result
                }
                return String(total + (price * Double(item.quantity)))
            }
        }
    @objc func clearCart() {
            DispatchQueue.main.async {
                self.items.removeAll()
                self.selectedStore = nil
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    
    func prepareOrder(userId: String) -> [String: Any]? {
           guard let store = selectedStore, !items.isEmpty else {
               return nil
           }
           
           let orderItems = items.map { item in
               return [
                   "productId": item.product.productId,
                   "quantity": item.quantity,
                   "price": Double(item.product.productPrice) ?? 0.0
               ]
           }
           
           let totalAmount = items.reduce(0.0) { total, item in
               total + (Double(item.product.productPrice) ?? 0.0) * Double(item.quantity)
           }
           
           return [
               "userId": userId,
               "pharmacyId": store.id,
               "amount": totalAmount,
               "orderItem": orderItems
           ]
       }
       
       func getAuthToken() -> String? {
           return UserDefaults.standard.string(forKey: "authToken")
       }
    

}


struct CartItem: Identifiable {
    let id = UUID()
    let product: ProductDetails
    var quantity: Int
}
struct Product1: Identifiable {
    let id: String
    let productName: String
    let productPrice: String
    let imageSrc: String
    // ... other properties ...
}
