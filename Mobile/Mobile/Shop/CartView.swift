//
//  CartView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/20.
//

import SwiftUI

struct RV: View {
    @State private var isSelectionMode = false
    @State private var selectedProducts: Set<Int> = []
    
    
    let products: [Medi] = [
        Medi(id: 1, productName: "Medicine 1", productPrice: "$10.99", imageSrc: "https://example.com/image1.jpg"),
        Medi(id: 2, productName: "Medicine 1", productPrice: "$10.99", imageSrc: "https://example.com/image1.jpg"),
        Medi(id: 3, productName: "Medicine 1", productPrice: "$10.99", imageSrc: "https://example.com/image1.jpg"),
        Medi(id: 4, productName: "Medicine 1", productPrice: "$10.99", imageSrc: "https://example.com/image1.jpg"),
        Medi(id: 5, productName: "Medicine 2", productPrice: "$15.99", imageSrc: "https://example.com/image2.jpg"),
        Medi(id: 6, productName: "Medicine 3", productPrice: "$20.99", imageSrc: "https://example.com/image3.jpg"),
        // Add more sample products as needed
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing){
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 20)], spacing: 20) {
                    ForEach(products) { product in
                        
                        if isSelectionMode {
                            PC(product: product, isSelected: selectedProducts.contains(product.id))
                                .onTapGesture {
                                    toggleSelection(for: product.id)
                                }
                        } else {
                            NavigationLink(destination: Text("Product Details for \(product.productName)")) {
                                PC(product: product)
                            }
                        }
                            
                            
                    }
                }
                .padding()
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            
            Button(action: {
                            if isSelectionMode {
                                printSelectedProductIds()
                            }
                            isSelectionMode.toggle()
                            if !isSelectionMode {
                                selectedProducts.removeAll()
                            }
                        }) {
                            Text(isSelectionMode ? "Compare (\(selectedProducts.count))" : "Compare")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 60)
                                .background(isSelectionMode ? Color.blue : Color.black)
                                .cornerRadius(25)
                                .shadow(color: .gray, radius: 3, x: 1, y: 1)
                        }
                        .padding(.bottom, 40)
                        .padding(.trailing, 20)
        }
        
    }
    private func toggleSelection(for id: Int) {
            if selectedProducts.contains(id) {
                selectedProducts.remove(id)
            } else if selectedProducts.count < 5 {
                selectedProducts.insert(id)
            }
        }
    private func printSelectedProductIds() {
            print("Selected product IDs: \(selectedProducts)")
        }
}

struct PC: View {
    let product: Medi
    var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: product.imageSrc)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(product.productName)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)
                .frame(height: 40)
            
            Text("Price: \(product.productPrice)")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.gray)
        }
        .frame(width: 150)
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .overlay(
                isSelected ?
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 3)
                    : nil
            )
    }
}

struct Medi: Identifiable {
    let id: Int
    let productName: String
    let productPrice: String
    let imageSrc: String
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RV()
        }
    }
}
