import SwiftUI

struct CareResultView: View {
    @ObservedObject var HomeVM: HomeVM
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 30) {  // Increased spacing between cards
                ForEach(HomeVM.products) { product in
                    NavigationLink(destination: ProductDetailsView(productId: product.productId)) {
                        OlderModeProductCard(product: product)
                    }
                    .onAppear {
                        HomeVM.loadMoreProductsIfNeeded(currentProduct: product)
                    }
                }
                
                if HomeVM.isLoading {
                    ProgressView()
                        .frame(height: 100)
                }
            }
            .padding()
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct OlderModeProductCard: View {
    let product: Medicine
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {  // Changed to VStack and increased spacing
            AsyncImage(url: URL(string: product.imageSrc)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)  // Changed to .fit for better image display
                case .failure(_):
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 200, height: 200)  // Increased image size
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .center, spacing: 10) {  // Changed to center alignment
                Text(product.productName)
                    .scalableFont(size: 24, weight: .semibold)  // Increased font size
                    .lineLimit(2)
                    .multilineTextAlignment(.center)  // Center-aligned text
                
                Text("Price: \(product.productPrice)")
                    .scalableFont(size: 22)  // Increased font size
                    .foregroundColor(.blue)  // Changed color for better visibility
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)  // Increased padding
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)  // Slightly increased shadow
    }
}
