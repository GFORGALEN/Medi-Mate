import SwiftUI

struct ProductSearchResultsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var tabBarManager: TabBarManager

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 20)], spacing: 20) {
                ForEach(viewModel.products) { product in
                    NavigationLink(destination: ProductDetailsView(productId: product.productId)) {
                        ProductCard(product: product)
                            .onAppear {
                                viewModel.loadMoreProductsIfNeeded(currentProduct: product)
                            }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: 150, height: 150)
                }
            }
            .padding()
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tabBarManager.isVisible = false
            if viewModel.products.isEmpty {
                viewModel.loadMoreProductsIfNeeded(currentProduct: nil)
            }
        }
        .onDisappear {
            tabBarManager.isVisible = false
        }
    }
}

struct ProductCard: View {
    let product: Medicine
    
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
    }
}
