import SwiftUI

struct ResultsView: View {
    @ObservedObject var HomeVM: HomeVM
    @StateObject private var comparisonViewModel = ComparisonViewModel()
    @State private var isSelectionMode = false
    @State private var selectedProducts: Set<String> = []
    @State private var navigateToComparison = false
    @State private var selectedProductId: String?
    
    // New state variables for location feature
    @State private var isStoreSelectionPresented = false
    @State private var selectedStore: String?
    @State private var locationData: ProductLocationData?
    @State private var isShowingLocationView = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if HomeVM.products.isEmpty {
                                emptyResultsView
                            } else {
                                ForEach(HomeVM.products) { product in
                                    productView(for: product)
                                        .id(product.id)
                                        .onAppear {
                                            HomeVM.lastViewedItemId = product.id
                                            HomeVM.loadMoreProductsIfNeeded(currentProduct: product)
                                        }
                                }
                                if HomeVM.isLoading {
                                    ProgressView()
                                        .frame(height: 50)
                                }
                            }
                        }
                        .padding()
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
                
                Color(.secondarySystemBackground)
                    .frame(height: 49)
                    .opacity(0.01)
            }
            .navigationTitle(isSelectionMode ? "Select Products" : "Results")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingLocationView) {
                if let data = locationData {
                    NavigationStack {
                        LocationView(location: StoreLocation(rawValue: data.shelfNumber) ?? .a, productLocation: data)
                            .navigationBarItems(leading: Button("Back") {
                                isShowingLocationView = false
                            })
                    }
                }
            }
            .overlay(
                Group {
                    if isStoreSelectionPresented {
                        StoreSelectionPopup(
                            isPresented: $isStoreSelectionPresented,
                            selectedStore: $selectedStore,
                            productId: selectedProductId ?? ""
                        ) { data in
                            locationData = data
                            isShowingLocationView = true
                        }
                    }
                }
            )
        }
    }

    private var emptyResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No results found")
                .font(.title2)
                .fontWeight(.bold)
            Text("Try adjusting your search or take a clearer picture.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func productView(for product: Medicine) -> some View {
        Group {
            if isSelectionMode {
                ProductCard(product: product, isSelected: selectedProducts.contains(product.id), onLocationTap: {
                    isStoreSelectionPresented = true
                    selectedProductId = product.id  // 添加这行
                })
                .onTapGesture {
                    toggleSelection(for: product.id)
                }
            } else {
                NavigationLink(destination: ProductDetailsView(productId: product.id)) {
                    ProductCard(product: product, onLocationTap: {
                        isStoreSelectionPresented = true
                        selectedProductId = product.id  // 添加这行
                    })
                }
            }
        }
    }

    private var compareButton: some View {
        VStack {
            if isSelectionMode {
                HStack {
                    Button(action: {
                        if selectedProducts.count >= 2 {
                            navigateToComparison = true
                        }
                    }) {
                        Text("Compare (\(selectedProducts.count))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(selectedProducts.count >= 2 ? Color.blue : Color.gray)
                            .cornerRadius(25)
                    }
                    .disabled(selectedProducts.count < 2)
                    
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
            } else {
                Button(action: {
                    isSelectionMode.toggle()
                    selectedProducts.removeAll()
                }) {
                    Text("Compare")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(Color.white.shadow(radius: 5))
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
    var onLocationTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 12) {
                    productImage
                    productInfo
                    Spacer()
                }
                .padding()
                
                Button(action: onLocationTap) {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                .position(x: geometry.size.width - 25, y: geometry.size.height - 25)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .frame(height: 100)
    }
    
    private var productImage: some View {
        AsyncImage(url: URL(string: product.imageSrc)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 80, height: 80)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                    .frame(width: 80, height: 80)
            @unknown default:
                EmptyView()
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.productName)
                .font(.headline)
                .lineLimit(2)
            Text("Price: \(product.productPrice)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let manufacturer = product.manufacturerName {
                Text(manufacturer)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
