//
//  SeniorFriendlyResultsView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/21.
//

import SwiftUI

struct SeniorFriendlyResultsView: View {
    @ObservedObject var viewModel: HomeVM

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {
                ForEach(viewModel.products) { product in
                    NavigationLink(destination: ProductDetailsView(productId: product.productId)) {
                        EnlargedSeniorFriendlyProductCard(product: product)
                            .onAppear {
                                viewModel.loadMoreProductsIfNeeded(currentProduct: product)
                            }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(height: 100)
                }
            }
            .padding()
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel.products.isEmpty {
                viewModel.loadMoreProductsIfNeeded(currentProduct: nil)
            }
        }
    }
}

struct EnlargedSeniorFriendlyProductCard: View {
    let product: Medicine
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: product.imageSrc)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .scaleEffect(2)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                        .font(.system(size: 80))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 240, height: 240)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .center, spacing: 15) {
                Text(product.productName)
                    .font(.system(size: 28, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Text("Price: \(product.productPrice)")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
        }
        .frame(width: 300, height: 400)
        .background(Color(.systemBackground))
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
        )
    }
}
