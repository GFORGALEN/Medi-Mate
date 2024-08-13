import SwiftUI

struct ProductCard: View {
    let product: Product
    let isSelectable: Bool
    @Binding var selectedProducts: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: product.imageURL)) { phase in
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
            
            Text(product.name)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(height: 40)
        }
        .frame(width: 150)
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .onTapGesture {
            if isSelectable {
                if selectedProducts.contains(product.id) {
                    selectedProducts.remove(product.id)
                } else {
                    selectedProducts.insert(product.id)
                }
            }
        }
    }
    
    @ViewBuilder
    private var selectionOverlay: some View {
        if selectedProducts.contains(product.id) {
            Color.blue.opacity(0.3)
                .overlay(
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                )
        }
    }
}

struct ProductGridView: View {
    let products: [Product]
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 170), spacing: 20)
    ]
    let isSelectable: Bool
    @Binding var selectedProducts: Set<String>
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(products) { product in
                    ProductCard(product: product, isSelectable: isSelectable, selectedProducts: $selectedProducts)
                }
            }
            .padding()
        }
    }
}
struct ProductSearchResultsView: View {
    let products: [Product]
    @State private var isSelectMode = false
    @State private var selectedProducts: Set<String> = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ProductGridView(products: products, isSelectable: isSelectMode, selectedProducts: $selectedProducts)
            
            if isSelectMode {
                compareButton
            } else {
                selectButton
            }
        }
        .navigationTitle("Results (\(products.count))")
        .navigationBarTitleDisplayMode(.inline)
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


#Preview {
    ProductSearchResultsView(products: [
        Product(id: "0", name: "iPhone 13", imageURL: "https://example.com/iphone13.jpg"),
        Product(id: "1", name: "MacBook Pro", imageURL: "https://example.com/macbookpro.jpg"),
        Product(id: "2", name: "AirPods Pro", imageURL: "https://example.com/airpodspro.jpg"),
        Product(id: "3", name: "iPad Air", imageURL: "https://example.com/ipadair.jpg"),
        Product(id: "4", name: "Apple Watch Series 7", imageURL: "https://example.com/applewatch7.jpg"),
        Product(id: "5", name: "iMac", imageURL: "https://example.com/imac.jpg"),
        Product(id: "6", name: "Mac mini", imageURL: "https://example.com/macmini.jpg")
    ])
}
