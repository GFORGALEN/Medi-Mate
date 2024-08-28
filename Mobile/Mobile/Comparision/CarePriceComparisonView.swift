//
//  CarePriceComparisonView.swift
//  Mobile
//
//  Created by Lykheang Taing on 28/08/2024.
//

import Foundation
import SwiftUI

struct CarePriceComparisonView: View {
    let comparisons: [Comparison]

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text("Price Comparison")
                .font(.system(size: 40, weight: .bold))
                .padding(.bottom, 20)

            ForEach(comparisons, id: \.productId) { comparison in
                VStack(alignment: .leading, spacing: 20) {
                    Text(comparison.productName)
                        .font(.system(size: 32, weight: .semibold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(height: 60)

                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: CGFloat(priceValue(comparison.productPrice)) / CGFloat(maxPrice()) * geometry.size.width, height: 60)
                        }
                        .cornerRadius(30)
                    }
                    .frame(height: 60)

                    Text(comparison.productPrice)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 30)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
            }
        }
        .padding(40)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(40)
    }

    private func priceValue(_ priceString: String) -> Double {
        let numericString = priceString.dropFirst().replacingOccurrences(of: ",", with: "")
        return Double(numericString) ?? 0
    }

    private func maxPrice() -> Double {
        comparisons.map { priceValue($0.productPrice) }.max() ?? 1
    }
}
