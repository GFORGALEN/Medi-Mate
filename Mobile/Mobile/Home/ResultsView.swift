import SwiftUI

struct ProductSearchResultsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isSelectMode = false
    @State private var selectedProducts: Set<String> = []
    @State private var selectedProductId: String?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ProductGridView(products: viewModel.products, isSelectable: isSelectMode, selectedProducts: $selectedProducts, onProductTap: { productId in
                selectedProductId = productId
            })
            
            if isSelectMode {
                compareButton
            } else {
                selectButton
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: Binding(
            get: { selectedProductId.map { ProductIdentifier(id: $0) } },
            set: { selectedProductId = $0?.id }
        )) { productIdentifier in
            ProductDetailsView(productId: productIdentifier.id)
        }
    }
    
    private var selectButton: some View {
        Button(action: {
            isSelectMode.toggle()
        }) {
            Text("Select for Comparison")
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: 200)
                .background(Color("bar"))
                .foregroundColor(.white)
                .cornerRadius(60)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var compareButton: some View {
        Button(action: {
            compareProducts()
            isSelectMode.toggle()
            selectedProducts.removeAll()
        }) {
            Text("Compare Selected (\(selectedProducts.count))")
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: 200)
                .background(selectedProducts.count >= 2 ? Color("Button") : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(60)
        }
        .disabled(selectedProducts.count < 2)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func compareProducts() {
        // 实现比较功能
        print("Comparing products with IDs: \(selectedProducts)")
    }
}

struct ProductGridView: View {
    let products: [Product1]
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 20)
    ]
    let isSelectable: Bool
    @Binding var selectedProducts: Set<String>
    let onProductTap: (String) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                    ProductCard(product: product, isSelectable: isSelectable, selectedProducts: $selectedProducts, onProductTap: onProductTap)
                }
            }
            .padding()
        }
    }
}

struct ProductCard: View {
    let product: Product1
    let isSelectable: Bool
    @Binding var selectedProducts: Set<String>
    let onProductTap: (String) -> Void
    
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
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                isSelectable ? selectionOverlay : nil
            )
            
            Text(product.productName)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(height: 40)
            
            HStack {
                Text("Price: \(product.productPrice)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    onProductTap(product.productId)
                }) {
                    Text("Detail")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isSelectable)
            }
        }
        .frame(width: 150)
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .onTapGesture {
            if isSelectable {
                if selectedProducts.contains(product.productId) {
                    selectedProducts.remove(product.productId)
                } else {
                    selectedProducts.insert(product.productId)
                }
            }
        }
    }
    
    @ViewBuilder
    private var selectionOverlay: some View {
        if selectedProducts.contains(product.productId) {
            Color.blue.opacity(0.3)
                .overlay(
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                )
        }
    }
}

// 预览
struct ProductSearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
            ProductSearchResultsView(viewModel: HomeViewModel())
        }
}

struct ProductIdentifier: Identifiable {
    let id: String
}
