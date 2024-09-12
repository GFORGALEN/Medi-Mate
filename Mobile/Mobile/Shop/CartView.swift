import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var authViewModel: AuthenticationView
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @State private var selectedStore: Store?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: isOlderMode ? 24 : 16) {
                    Text("Your Cart")
                        .font(.system(size: isOlderMode ? 36 : 28, weight: .bold))
                        .scalableFont(size: isOlderMode ? 36 : 28)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, isOlderMode ? 50 : 40)
                    
                    storeSelectionSection
                    
                    if cartManager.items.isEmpty {
                        emptyCartView
                    } else {
                        cartItemsList
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: isOlderMode ? 70 : 50)
            }
            
            if !cartManager.items.isEmpty {
                VStack(spacing: isOlderMode ? 24 : 16) {
                    totalSection
                    checkoutButton
                }
                .padding(.horizontal)
                .padding(.bottom, isOlderMode ? 90 : 75)
            }
            
            Color(.secondarySystemBackground)
                .frame(height: isOlderMode ? 60 : 49)
                .opacity(0.01)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Order Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var storeSelectionSection: some View {
        VStack(alignment: .leading, spacing: isOlderMode ? 16 : 12) {
            Text("Pickup Location")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 28 : 20)
                .foregroundColor(.primary)
            
            HStack {
                Text("Choose location")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .scalableFont(size: isOlderMode ? 24 : 16)
                
                Spacer()
                
                Picker("", selection: $cartManager.selectedStore) {
                    Text("Select a store").tag(nil as Store?)
                    ForEach(stores) { store in
                        Text(store.name).tag(store as Store?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .scalableFont(size: isOlderMode ? 24 : 16)
                .accentColor(.blue)
            }
            
            if let store = cartManager.selectedStore {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Selected: \(store.name)")
                        .scalableFont(size: isOlderMode ? 22 : 14)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Please select a pickup location")
                    .scalableFont(size: isOlderMode ? 22 : 14)
                    .foregroundColor(.red)
            }
        }
        .padding(isOlderMode ? 20 : 16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(isOlderMode ? 16 : 12)
        .frame(maxWidth: .infinity)
    }
    
    private var emptyCartView: some View {
        VStack(spacing: isOlderMode ? 30 : 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: isOlderMode ? 84 : 60))
                .foregroundColor(.gray)
            Text("Your cart is empty")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 28 : 20)
            Text("Add some items to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .scalableFont(size: isOlderMode ? 22 : 16)
        }
        .frame(maxWidth: .infinity)
        .padding(isOlderMode ? 24 : 16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(isOlderMode ? 16 : 12)
        .padding(.horizontal)
    }
    
    private var cartItemsList: some View {
        VStack(spacing: isOlderMode ? 24 : 12) {
            ForEach(cartManager.items) { item in
                CartItemCard(item: item)
            }
        }
        .padding(.horizontal)
    }
    
    private var totalSection: some View {
        HStack {
            Text("Total")
                .font(.headline)
                .scalableFont(size: isOlderMode ? 28 : 20)
            Spacer()
            Text(formatPrice(cartManager.totalPrice))
                .font(.headline)
                .scalableFont(size: isOlderMode ? 28 : 20)
        }
        .padding(isOlderMode ? 20 : 16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(isOlderMode ? 14 : 10)
    }
    
    private var checkoutButton: some View {
            Button(action: {
                guard let store = cartManager.selectedStore else {
                    showingAlert = true
                    alertMessage = "Please select a store"
                    return
                }
                
                guard !authViewModel.userId.isEmpty else {
                    showingAlert = true
                    alertMessage = "User ID not available. Please log in again."
                    return
                }
                
                guard let order = cartManager.prepareOrder(userId: authViewModel.userId) else {
                    showingAlert = true
                    alertMessage = "Failed to prepare order"
                    return
                }
                
                submitOrder(order, cartManager: cartManager) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let message):
                            print("Order submitted successfully: \(message)")
                            self.cartManager.clearCart()
                            showingAlert = true
                            alertMessage = "Order submitted successfully!"
                        case .failure(let error):
                            print("Failed to submit order: \(error.localizedDescription)")
                            showingAlert = true
                            alertMessage = "Failed to submit order: \(error.localizedDescription)"
                        }
                    }
                }
            }) {
                Text(cartManager.selectedStore == nil ? "Select a Store to Checkout" : "Proceed to Checkout")
                    .font(.headline)
                    .scalableFont(size: isOlderMode ? 26 : 18)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, isOlderMode ? 20 : 15)
                    .background(cartManager.selectedStore == nil ? Color.gray.opacity(0.7) : Color.blue)
                    .cornerRadius(isOlderMode ? 20 : 15)
            }
            .padding(.horizontal, isOlderMode ? 10 : 20)
            .shadow(radius: 3, y: 2)
            .disabled(cartManager.selectedStore == nil || cartManager.items.isEmpty || authViewModel.userId.isEmpty)
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
        VStack(alignment: .leading, spacing: isOlderMode ? 16 : 12) {
            HStack(alignment: .top, spacing: isOlderMode ? 16 : 12) {
                productImage
                VStack(alignment: .leading, spacing: isOlderMode ? 8 : 4) {
                    productInfo
                    quantityControl
                }
            }
            
            Divider()
            
            removeButton
        }
        .padding(isOlderMode ? 20 : 16)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(isOlderMode ? 16 : 12)
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
        .frame(width: isOlderMode ? 100 : 80, height: isOlderMode ? 100 : 80)
        .cornerRadius(isOlderMode ? 12 : 8)
    }
    
    private var productInfo: some View {
        VStack(alignment: .leading, spacing: isOlderMode ? 8 : 4) {
            Text(item.product.productName)
                .font(.headline)
                .scalableFont(size: isOlderMode ? 24 : 18)
                .lineLimit(2)
            Text("$\(item.product.productPrice)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .scalableFont(size: isOlderMode ? 22 : 16)
        }
    }
    
    private var quantityControl: some View {
        HStack(spacing: isOlderMode ? 20 : 15) {
            Text("Quantity:")
                .scalableFont(size: isOlderMode ? 22 : 16)
            
            Button(action: {
                if item.quantity > 1 {
                    cartManager.updateQuantity(for: item.product, quantity: item.quantity - 1)
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.blue)
                    .scalableFont(size: isOlderMode ? 30 : 24)
            }
            .disabled(item.quantity <= 1)
            
            Text("\(item.quantity)")
                .frame(minWidth: isOlderMode ? 40 : 30)
                .scalableFont(size: isOlderMode ? 22 : 16)
            
            Button(action: {
                cartManager.updateQuantity(for: item.product, quantity: item.quantity + 1)
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .scalableFont(size: isOlderMode ? 30 : 24)
            }
        }
    }
    
    private var removeButton: some View {
        Button(action: {
            cartManager.removeFromCart(item.product)
        }) {
            HStack {
                Image(systemName: "trash")
                Text("Remove")
            }
            .foregroundColor(.red)
            .scalableFont(size: isOlderMode ? 22 : 18)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.red.opacity(0.1))
            .cornerRadius(isOlderMode ? 12 : 8)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
