//
//  CardView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/13.
//

//import SwiftUI
//
//
//struct ProductCard: View {
//    let product: Product
//    
//    var body: some View {
//        VStack {
//            AsyncImage(url: URL(string: product.imageURL)) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 150, height: 150)
//                    .clipped()
//                    .cornerRadius(10)
//            } placeholder: {
//                ProgressView()
//            }
//            .frame(width: 150, height: 150)
//            
//            Text(product.name)
//                .font(.caption)
//                .lineLimit(2)
//                .multilineTextAlignment(.center)
//                .frame(width: 150)
//        }
//        .padding(.bottom)
//    }
//}
//
//struct ProductGridView: View {
//    let products: [Product]
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//    
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: columns, spacing: 20) {
//                ForEach(products) { product in
//                    ProductCard(product: product)
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//struct ProductSearchResultsView: View {
//    let products: [Product]
//    
//    var body: some View {
//        NavigationView {
//            ProductGridView(products: products)
//                .navigationTitle("Result")
//        }
//    }
//}
//
//
//#Preview {
//    ProductSearchResultsView(products: [
//        Product(id:"0",name: "iPhone 13", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_800.jpg"),
//        Product(id:"0",name: "MacBook Pro", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_200.jpg"),
//        Product(id:"0",name: "AirPods Pro", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_200.jpg"),
//        Product(id:"0",name: "iPad Air", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_200.jpg"),
//        Product(id:"0",name: "Apple Watch Series 7", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_200.jpg"),
//        Product(id:"0",name: "Apple Watch Series 7", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_200.jpg"),
//        Product(id:"0",name: "Apple Watch Series 7", imageURL: "https://static.chemistwarehouse.co.nz/ams/media/pi/138517/2DF_200.jpg")
//
//    ])
//}
