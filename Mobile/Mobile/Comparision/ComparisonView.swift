import SwiftUI

struct ComparisonView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    let productIds: [String]

    var body: some View {
        NavigationView {
            ZStack {
//                backgroundGradient
                
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.comparisons.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            PriceComparisonView(comparisons: viewModel.comparisons)
                            ComparisonCardsView(comparisons: viewModel.comparisons)
                            AIInsightsButton(comparisons: viewModel.comparisons)
                            Spacer()
                                .frame(height: 40)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Comparison")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.fetchComparisons(productIds: productIds)
        }
    }
    
//    private var backgroundGradient: some View {
//        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
//                       startPoint: .topLeading,
//                       endPoint: .bottomTrailing)
//            .edgesIgnoringSafeArea(.all)
//    }
}

struct PriceComparisonView: View {
    let comparisons: [Comparison]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Price Comparison")
                .font(.headline)
            
            ForEach(comparisons, id: \.productId) { comparison in
                HStack {
                    Text(comparison.productName)
                        .font(.subheadline)
                        .frame(width: 100, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: geometry.size.width)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: CGFloat(priceValue(comparison.productPrice)) / CGFloat(maxPrice()) * geometry.size.width)
                        }
                    }
                    .frame(height: 20)
                    .cornerRadius(10)
                    
                    Text(comparison.productPrice)
                        .font(.subheadline)
                        .frame(width: 60, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func priceValue(_ priceString: String) -> Double {
        let numericString = priceString.dropFirst().replacingOccurrences(of: ",", with: "")
        return Double(numericString) ?? 0
    }
    
    private func maxPrice() -> Double {
        comparisons.map { priceValue($0.productPrice) }.max() ?? 1
    }
}

struct ComparisonCardsView: View {
    let comparisons: [Comparison]
    @State private var expandedCard: String?
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(comparisons, id: \.productId) { comparison in
                ComparisonCard(comparison: comparison, isExpanded: expandedCard == comparison.productId)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            expandedCard = (expandedCard == comparison.productId) ? nil : comparison.productId
                        }
                    }
            }
        }
    }
}

struct ComparisonCard: View {
    let comparison: Comparison
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: URL(string: comparison.imageSrc)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(comparison.productName)
                        .font(.headline)
                    Text(comparison.productPrice)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            
            if isExpanded {
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    DetailRow(title: "Common Use", detail: comparison.commonUse)
                    DetailRow(title: "Warnings", detail: comparison.warnings)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct DetailRow: View {
    let title: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(detail)
                .font(.body)
        }
    }
}

struct AIInsightsButton: View {
    let comparisons: [Comparison]
    @State private var showingInsights = false
    
    var body: some View {
        Button(action: {
            showingInsights = true
        }) {
            HStack {
                Image(systemName: "brain.head.profile")
                Text("AI Insights")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15)
        }
        .sheet(isPresented: $showingInsights) {
            AIInsightsView(comparisons: comparisons)
        }
    }
}

struct AIInsightsView: View {
    let comparisons: [Comparison]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(comparisons, id: \.productId) { comparison in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(comparison.productName)
                                .font(.headline)
                            Text(comparison.difference)
                                .font(.body)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("AI Insights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading comparisons...")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No comparisons available")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Try selecting different products or check back later.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
