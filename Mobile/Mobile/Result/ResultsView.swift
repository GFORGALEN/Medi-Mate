import SwiftUI

struct ResultsView: View {
    @ObservedObject var HomeVM: HomeVM
    @StateObject private var comparisonViewModel = ComparisonViewModel()
    @State private var isSelectionMode = false
    @State private var selectedProducts: Set<String> = []
    @State private var navigateToComparison = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        if HomeVM.products.isEmpty {
                            emptyResultsView
                        } else {
                            productsGrid(proxy: proxy)
                        }
                    }
                    .onAppear {
                        if let id = HomeVM.lastViewedItemId {
                            proxy.scrollTo(id, anchor: .top)
                        }
                    }
                }
                
                if !HomeVM.products.isEmpty {
                    compareButton
                        .padding(.bottom, 80)
                }
                
                // Placeholder for tab bar
                Color(.secondarySystemBackground)
                    .frame(height: 49)
                    .opacity(0.01)
            }
            .navigationTitle(isSelectionMode ? "Select Products" : "Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isSelectionMode {
                        clearButton
                    }
                }
            }
        }
    }

    private var emptyResultsView: some View {
        VStack {
            Spacer()
            Text("Sorry There is no result, please re-enter the keyword or take a clearer picture of the front of the package.")
                .font(.system(size: 30, weight: .bold))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            Spacer()
        }
    }

    private func productsGrid(proxy: ScrollViewProxy) -> some View {
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
                    .id(product.id)
                    .onAppear {
                        HomeVM.lastViewedItemId = product.id
                        HomeVM.loadMoreProductsIfNeeded(currentProduct: product)
                    }
                }

                if HomeVM.isLoading {
                    CustomLoadingView()
                        .frame(width: 150, height: 150)
                }
            }
            .padding()
        }

    private var clearButton: some View {
        Button(action: {
            HomeVM.clearSearchResults()
        }) {
            Text("Clear")
                .foregroundColor(.blue)
        }
    }

    private var compareButton: some View {
        HStack {
            Button(action: {
                if isSelectionMode {
                    if selectedProducts.count >= 2 {
                        navigateToComparison = true
                    }
                } else {
                    isSelectionMode.toggle()
                    selectedProducts.removeAll()
                }
            }) {
                Text(isSelectionMode ? "Compare (\(selectedProducts.count))" : "Compare")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        isSelectionMode && selectedProducts.count < 2
                        ? Color.gray
                        : (isSelectionMode ? Color.blue : Color.black)
                    )
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .shadow(radius: 3, y: 2)
            .disabled(isSelectionMode && selectedProducts.count < 2)
            
            if isSelectionMode {
                Button(action: {
                    isSelectionMode = false
                    selectedProducts.removeAll()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                .padding(.leading, 8)
            }
        }
        .frame(height: 60)
        .padding(.horizontal)
    }

    private func toggleSelection(for id: String) {
        if selectedProducts.contains(id) {
            selectedProducts.remove(id)
        } else if selectedProducts.count < 5 {
            selectedProducts.insert(id)
        }
    }
}

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
