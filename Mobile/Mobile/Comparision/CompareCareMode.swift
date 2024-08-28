import SwiftUI

struct CompareCareMode: View {
    @ObservedObject var viewModel: ComparisonViewModel
    let productIds: [String]
    @State private var expandedCard: String?
    @State private var showingAIInsights = false
    @State private var animationOffset: CGFloat = 0

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 40) {
                    if !viewModel.isLoading && !viewModel.comparisons.isEmpty {
                        CarePriceComparisonView(comparisons: viewModel.comparisons)
                            .padding(.horizontal)

                        ForEach(viewModel.comparisons, id: \.productId) { comparison in
                            ComparisonCareCard(comparison: comparison, isExpanded: expandedCard == comparison.productId)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        expandedCard = (expandedCard == comparison.productId) ? nil : comparison.productId
                                    }
                                }
                        }

                        aiInsightsButton

                        Spacer()
                            .frame(height: 100)
                    }
                }
                .padding()
            }

            if viewModel.isLoading {
                analyzingProductsAnimation
            }
        }
        .navigationTitle("Comparison")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchComparisons(productIds: productIds)
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animationOffset = 20
            }
        }
        .sheet(isPresented: $showingAIInsights) {
            AIInsightsView(comparisons: viewModel.comparisons)
        }
    }

    private var aiInsightsButton: some View {
        Button(action: {
            showingAIInsights = true
        }) {
            HStack {
                Image(systemName: "brain.head.profile")
                Text("AI Insights")
            }
            .font(.system(size: 28, weight: .bold))  // Increased font size
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(25)  // Increased corner radius
        }
    }

    private var analyzingProductsAnimation: some View {
        VStack(spacing: 30) {  // Increased spacing
            Text("Analyzing")
                .font(.system(size: 36, weight: .bold))  // Increased font size
                .foregroundColor(.blue)

            Text("Products")
                .font(.system(size: 36, weight: .bold))  // Increased font size
                .foregroundColor(.blue)
                .offset(y: animationOffset)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2.0)  // Increased size
        }
        .frame(width: 250, height: 250)  // Increased frame size
        .background(Color.white.opacity(0.9))
        .cornerRadius(25)  // Increased corner radius
        .shadow(radius: 15)  // Increased shadow
    }
}

struct ComparisonCareCard: View {
    let comparison: Comparison
    let isExpanded: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {  // Increased spacing
            AsyncImage(url: URL(string: comparison.imageSrc)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 250, height: 250)  // Increased image size
            .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .center, spacing: 15) {  // Increased spacing
                Text(comparison.productName)
                    .font(.system(size: 24, weight: .bold))  // Increased font size
                    .multilineTextAlignment(.center)
                Text(comparison.productPrice)
                    .font(.system(size: 28, weight: .semibold))  // Increased font size
                    .foregroundColor(.blue)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 15) {  // Increased spacing
                    CareDetailRow(title: "Common Use", detail: comparison.commonUse)
                    CareDetailRow(title: "Warnings", detail: comparison.warnings)
                }
                .transition(.opacity)
            }

            Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                .foregroundColor(.blue)
                .font(.system(size: 30))  // Increased icon size
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(25)  // Increased corner radius
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)  // Increased shadow
    }
}

struct CareDetailRow: View {
    let title: String
    let detail: String

       var body: some View {
           VStack(alignment: .leading, spacing: 8) {
               Text(title)
                   .font(.system(size: 24, weight: .semibold))  // Increased size, semibold weight
                   .foregroundColor(.gray)  // Changed color to gray
               Text(detail)
                   .font(.system(size: 20))  // Increased size for description
                   .foregroundColor(.black)  // Ensure description is black for readability
           }
       }
   }

struct CareAIInsightsView: View {
    let comparisons: [Comparison]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {  // Increased spacing
                    ForEach(comparisons, id: \.productId) { comparison in
                        VStack(alignment: .leading, spacing: 15) {  // Increased spacing
                            Text(comparison.productName)
                                .font(.system(size: 24, weight: .bold))  // Increased font size
                            Text(comparison.difference)
                                .font(.system(size: 18))  // Increased font size
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)  // Increased corner radius
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
                    .font(.system(size: 20, weight: .semibold))  // Increased font size
                }
            }
        }
    }
}

struct CareLoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)  // Increased size
            Text("Loading comparisons...")
                .font(.system(size: 22, weight: .semibold))  // Increased font size
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

struct CareEmptyStateView: View {
    var body: some View {
        VStack(spacing: 30) {  // Increased spacing
            Image(systemName: "magnifyingglass")
                .font(.system(size: 80))  // Increased icon size
                .foregroundColor(.gray)
            Text("No comparisons available")
                .font(.system(size: 28, weight: .bold))  // Increased font size
            Text("Try selecting different products or check back later.")
                .font(.system(size: 20))  // Increased font size
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}








