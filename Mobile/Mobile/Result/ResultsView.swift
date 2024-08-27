import SwiftUI

struct ResultsView: View {
    @ObservedObject var HomeVM: HomeVM
    @StateObject private var comparisonViewModel = ComparisonViewModel()
    @State private var isSelectionMode = false
    @State private var selectedProducts: Set<String> = []
    @State private var navigateToComparison = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    if HomeVM.products.isEmpty {
                        VStack {
                            Spacer()
                            Text("Sorry There is no result, please re-enter the keyword or take a clearer picture of the front of the package.")
                                .font(.system(size: 30, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                            Spacer()
                        }
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 20)], spacing: 20) {
                            ForEach(HomeVM.products) { product in
                                Group {
                                    if isSelectionMode {
                                        ProductCard(product: product, isSelected: selectedProducts.contains(product.id))
                                            .onTapGesture {
                                                toggleSelection(for: product.id)
                                            }
                                    } else {
                                        NavigationLink(destination: ProductDetailsView(productId: product.id)) {
                                            ProductCard(product: product)
                                        }
                                    }
                                }
                                .onAppear {
                                    HomeVM.loadMoreProductsIfNeeded(currentProduct: product)
                                }
                            }

                            if HomeVM.isLoading {
                                CustomLoadingView()
                                    .frame(width: 150, height: 150)
                            }
                        }
                        .padding()

                        // Add bottom spacing
                        Spacer()
                            .frame(height: 100)
                    }
                }
                .navigationTitle("Results")
                .navigationBarTitleDisplayMode(.inline)

                if !HomeVM.products.isEmpty {
                    Button(action: {
                        if isSelectionMode && !selectedProducts.isEmpty {
                            navigateToComparison = true
                        } else {
                            isSelectionMode.toggle()
                            selectedProducts.removeAll()
                        }
                    }) {
                        Text(isSelectionMode ? "Compare (\(selectedProducts.count))" : "Compare")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 60)
                            .background(isSelectionMode ? Color.blue : Color.black)
                            .cornerRadius(25)
                            .shadow(color: .gray, radius: 3, x: 1, y: 1)
                    }
                    .padding(.bottom, 50)
                    .padding(.trailing, 20)
                    .disabled(isSelectionMode && selectedProducts.isEmpty)
                }
            }
            .navigationDestination(for: String.self) { productId in
                ProductDetailsView(productId: productId)
            }
            .navigationDestination(isPresented: $navigateToComparison) {
                ComparisonView(viewModel: ComparisonViewModel(), productIds: Array(selectedProducts))
            }
        }
    }

    // ... rest of the code remains the same


    private func toggleSelection(for id: String) {
        if selectedProducts.contains(id) {
            selectedProducts.remove(id)
        } else if selectedProducts.count < 5 {
            selectedProducts.insert(id)
        }
    }
    
    // ProductCard struct remains unchanged
    struct ProductCard: View {
        let product: Medicine
        var isSelected: Bool = false
        
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
            .overlay(
                isSelected ?
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 3)
                : nil
            )
        }
    }
}
