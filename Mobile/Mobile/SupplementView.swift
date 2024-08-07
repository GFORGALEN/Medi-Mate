//
//  SupplementView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/7.
//

//import SwiftUI
//import StoreKit
//
//struct ProductDetailView: View {
//    var product: Product
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                Text(product.productName)
//                    .font(.title)
//                Text("Price: $\(product.productPrice, specifier: "%.2f")")
//                Text(product.generalInformation)
//                    .font(.body)
//                Text("Ingredients: \(product.ingredients)")
//                    .font(.caption)
//                AsyncImage(url: product.imageSrc) { image in
//                    image.resizable()
//                } placeholder: {
//                    ProgressView()
//                }
//                .frame(width: 200, height: 200)
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//        .navigationTitle("Product Details")
//    }
//}
//
//
//
//struct ProductDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductDetailView(product: Product(
//            productName: "Example Product",
//            productPrice: 19.99,
//            manufacturerName: "Example Maker",
//            productId: "123",
//            generalInformation: "Some info",
//            warnings: "Some warnings",
//            commonUse: "Common use",
//            ingredients: "Ingredients",
//            directions: "Use it like this",
//            imageSrc: URL(string: "https://example.com/image.jpg")!
//        ))
//    }
//}
