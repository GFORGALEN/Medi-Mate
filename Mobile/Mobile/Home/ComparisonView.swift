//
//  ComparisonView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/21.
//

import SwiftUI

struct ComparisonView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    let productIds: [String]
    
    init(viewModel: ComparisonViewModel, productIds: [String]) {
        self.viewModel = viewModel
        self.productIds = productIds
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Product Comparison")
                    .font(.largeTitle)
                    .padding()
                
                if viewModel.comparisons.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 20) {
                            ForEach(viewModel.comparisons, id: \.productId) { product in
                                ProductComparisonCard(product: product)
                            }
                        }
                        .padding()
                    }
                    
                    ComparisonTable(comparisons: viewModel.comparisons)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchComparisons(productIds: productIds)
            }
        }
    }
}

struct ProductComparisonCard: View {
    let product: Comparison
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: product.imageSrc)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(product.productName)
                .font(.headline)
                .lineLimit(2)
            
            Text("$\(product.productPrice)")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .frame(width: 170)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ComparisonTable: View {
    let comparisons: [Comparison]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ComparisonRow(title: "Common Use", values: comparisons.map { $0.commonUse })
            ComparisonRow(title: "Warnings", values: comparisons.map { $0.warnings })
            ComparisonRow(title: "Difference", values: comparisons.map { $0.difference })
        }
        .padding()
    }
}

struct ComparisonRow: View {
    let title: String
    let values: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            ForEach(values.indices, id: \.self) { index in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(values[index])
                        .font(.subheadline)
                }
            }
        }
    }
}
