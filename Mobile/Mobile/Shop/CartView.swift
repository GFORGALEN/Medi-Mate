import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var authViewModel: AuthenticationView
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @State private var selectedStore: Store?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Cart")
                    .font(.system(size: isOlderMode ? 32 : 28, weight: .bold))
                    .scalableFont(size: isOlderMode ? 32 : 28)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                storeSelectionSection
                
                if cartManager.items.isEmpty {
                    emptyCartView
                } else {
                    cartItemsList
                    totalSection
                    checkoutButton
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var storeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Pickup Store:")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 22 : 18)
            
            Picker("Select Store", selection: $cartManager.selectedStore) {
                Text("Select a store").tag(nil as Store?)
                ForEach(stores) { store in
                    Text("\(store.name) (ID: \(store.id))").tag(store as Store?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .scalableFont(size: isOlderMode ? 20 : 16)
            
            if let store = cartManager.selectedStore {
                Text("Selected Store: \(store.name) (ID: \(store.id))")
                    .scalableFont(size: isOlderMode ? 18 : 14)
                    .foregroundColor(.secondary)
            } else {
                Text("No store selected")
                    .scalableFont(size: isOlderMode ? 18 : 14)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: isOlderMode ? 72 : 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 24 : 20)
            Text("Add some items to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .scalableFont(size: isOlderMode ? 18 : 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .padding()
    }
    
    private var cartItemsList: some View {
        VStack(spacing: isOlderMode ? 16 : 12) {
            ForEach(cartManager.items) { item in
                CartItemCard(item: item)
            }
        }
    }
    
    private var totalSection: some View {
        HStack {
            Text("Total")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 24 : 20)
            Spacer()
            Text(formatPrice(cartManager.totalPrice))
                .font(.headline)
                .scalableFont(size: isOlderMode ? 24 : 20)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private var checkoutButton: some View {
        Button(action: {
            guard let store = cartManager.selectedStore else {
                print("No store selected")
                return
            }
            
            guard !authViewModel.userId.isEmpty else {
                print("User ID not available")
                return
            }
            
            guard !authViewModel.token.isEmpty else {
                print("Authentication token not available")
                return
            }
            
            guard let order = cartManager.prepareOrder(userId: authViewModel.userId) else {
                print("Failed to prepare order")
                return
            }
            
            print("Submitting order:")
            print(order)
            
            submitOrder(order, token: authViewModel.token) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        print("Order submitted successfully: \(message)")
                        self.cartManager.clearCart()
                    case .failure(let error):
                        print("Failed to submit order: \(error.localizedDescription)")
                        if let nsError = error as NSError? {
                            print("Error Domain: \(nsError.domain)")
                            print("Error Code: \(nsError.code)")
                            print("Error User Info: \(nsError.userInfo)")
                        }
                    }
                }
            }
        }) {
            Text(cartManager.selectedStore == nil ? "Select a Store to Checkout" : "Proceed to Checkout")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 22 : 18)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(cartManager.selectedStore == nil || authViewModel.token.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(12)
        }
        .disabled(cartManager.selectedStore == nil || cartManager.items.isEmpty || authViewModel.userId.isEmpty || authViewModel.token.isEmpty)
    }
    
    private func formatPrice(_ price: String) -> String {
        guard let doublePrice = Double(price) else {
            return "Invalid Price"
        }
        return String(format: "$%.2f", doublePrice)
    }
}

struct CartItemCard: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    
    var body: some View {
        HStack(spacing: 12) {
            productImage
            
            VStack(alignment: .leading, spacing: 8) {
                productInfo
                HStack {
                    quantityControl
                    Spacer()
                    removeButton
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var productImage: some View {
        AsyncImage(url: URL(string: item.product.imageSrc)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 80, height: 80)
        .cornerRadius(8)
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.product.productName)
                .font(.headline)
                .scalableFont(size: isOlderMode ? 20 : 18)
                .lineLimit(2)
            Text("$\(item.product.productPrice)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .scalableFont(size: isOlderMode ? 18 : 16)
        }
    }
    
    private var quantityControl: some View {
        HStack {
            Text("Quantity:")
                .scalableFont(size: isOlderMode ? 18 : 16)
            Spacer()
            HStack(spacing: 15) {
                Button(action: {
                    if item.quantity > 1 {
                        cartManager.updateQuantity(for: item.product, quantity: item.quantity - 1)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.blue)
                }
                .disabled(item.quantity <= 1)
                
                Text("\(item.quantity)")
                    .frame(minWidth: 30)
                    .scalableFont(size: isOlderMode ? 18 : 16)
                
                Button(action: {
                    cartManager.updateQuantity(for: item.product, quantity: item.quantity + 1)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .scalableFont(size: isOlderMode ? 24 : 20)
        }
    }
    
    private var removeButton: some View {
        Button(action: {
            cartManager.removeFromCart(item.product)
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
                .scalableFont(size: isOlderMode ? 20 : 18)
        }
        .padding(.leading, 8)
    }
}
