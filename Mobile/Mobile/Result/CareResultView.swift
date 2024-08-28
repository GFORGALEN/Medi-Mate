import SwiftUI

struct CareResultView: View {
    @ObservedObject var HomeVM: HomeVM
    @State private var isSelectionMode = false
    @State private var selectedProducts: Set<String> = []
    @State private var navigateToComparison = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(HomeVM.products) { product in
                        Group {
                            if isSelectionMode {
                                OlderModeProductCard(product: product, isSelected: selectedProducts.contains(product.id))
                                    .onTapGesture {
                                        toggleSelection(for: product.id)
                                    }
                            } else {
                                NavigationLink(destination: ProductDetailsView(productId: product.id)) {
                                    OlderModeProductCard(product: product)
                                }
                            }
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

            compareButton
        }
        .navigationDestination(isPresented: $navigateToComparison) {
            CompareCareMode(viewModel: ComparisonViewModel(), productIds: Array(selectedProducts))
        }
    }

    private var compareButton: some View {
        Button(action: {
            if isSelectionMode && selectedProducts.count >= 2 {
                navigateToComparison = true
            } else if !isSelectionMode {
                isSelectionMode.toggle()
                selectedProducts.removeAll()
            }
        }) {
            Text(isSelectionMode ? "Compare (\(selectedProducts.count))" : "Compare")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 70)
                .background(
                    isSelectionMode && selectedProducts.count < 2
                    ? Color.gray
                    : (isSelectionMode ? Color.blue : Color.black)
                )
                .cornerRadius(35)
                .shadow(color: .gray, radius: 3, x: 1, y: 1)
        }
        .disabled(isSelectionMode && selectedProducts.count < 2)
        .padding(.bottom, 50)
        .padding(.trailing, 20)
    }

    private func toggleSelection(for id: String) {
        if selectedProducts.contains(id) {
            selectedProducts.remove(id)
        } else if selectedProducts.count < 5 {
            selectedProducts.insert(id)
        }
    }
}
struct OlderModeProductCard: View {
    let product: Medicine
    var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            AsyncImage(url: URL(string: product.imageSrc)) { phase in
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
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .center, spacing: 10) {
                Text(product.productName)
                    .font(.system(size: 24, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text("Price: \(product.productPrice)")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .overlay(
            isSelected ?
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 3)
            : nil
        )
    }
}
