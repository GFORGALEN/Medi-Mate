//
//  ProductDetailView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI

struct ProductDetailsView: View {
    let productId: String
    @StateObject private var viewModel: ProductDetailsViewModel
    
    init(productId: String) {
        self.productId = productId
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(productId: productId))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.error {
                ErrorView(error: error, retryAction: viewModel.loadProductDetails)
            } else if let details = viewModel.productDetails {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ProductImageView(imageSrc: details.imageSrc)
                        ProductInfoView(details: details)
                        Divider()
                        ProductDescriptionView(details: details)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Product Details")
        .onAppear {
            viewModel.loadProductDetails()
        }
    }
}


// MARK: - Subviews

private struct ProductImageView: View {
    let imageSrc: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageSrc)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure(_):
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: 200)
    }
}

private struct ProductInfoView: View {
    let details: ProductDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(details.productName)
                .font(.title)
                .fontWeight(.bold)
            Text("Price: \(details.productPrice)")
                .font(.headline)
            Text("Manufacturer: \(details.manufacturerName)")
                .font(.subheadline)
        }
    }
}

private struct ProductDescriptionView: View {
    let details: ProductDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            DescriptionSection(title: "Summary", content: details.summary)
            DescriptionSection(title: "General Information", content: details.generalInformation)
            DescriptionSection(title: "Warnings", content: details.warnings)
            DescriptionSection(title: "Common Use", content: details.commonUse)
            DescriptionSection(title: "Ingredients", content: details.ingredients)
            DescriptionSection(title: "Directions", content: details.directions)
        }
    }
}

private struct DescriptionSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
        }
    }
}

private struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry") {
                retryAction()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

