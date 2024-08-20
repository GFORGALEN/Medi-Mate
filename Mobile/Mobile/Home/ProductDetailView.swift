//
//  ProductDetailView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI

// MARK: - View

struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailsViewModel
    
    
    init(productId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(productId: productId))
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading...")
            case .loaded(let details):
                ProductDetailsContent(details: details)
            case .error(let error):
                ErrorView(error: error, retryAction: { Task { await viewModel.loadProductDetails() } })
            }
        }
        .navigationTitle("Product Details")
        .task {
            await viewModel.loadProductDetails()
        }
    }
}

// MARK: - Subviews

struct ProductDetailsContent: View {
    let details: ProductDetails
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: details.imageSrc)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo").foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 200)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(details.productName).font(.title).fontWeight(.bold)
                    Text("Price: \(details.productPrice)").font(.headline)
                    Text("Manufacturer: \(details.manufacturerName)").font(.subheadline)
                }
                
                Divider()
                
                ForEach([
                    ("Summary", details.summary),
                    ("General Information", details.generalInformation),
                    ("Warnings", details.warnings),
                    ("Common Use", details.commonUse),
                    ("Ingredients", details.ingredients),
                    ("Directions", details.directions)
                ], id: \.0) { title, content in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title).font(.headline)
                        Text(content).font(.body)
                    }
                }
            }
            .padding()
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry", action: retryAction)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// MARK: - Helper Structures

struct APIResponse<T: Codable>: Codable {
    let code: Int
    let msg: String?
    let data: T
}
