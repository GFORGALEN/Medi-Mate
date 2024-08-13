import SwiftUI

struct ShopView: View {
    @ObservedObject var authViewModel: AuthenticationView
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var showLoginView = false
    
    var body: some View {
        NavigationView {
            Group {
                if authViewModel.isLoginSuccessed {
                    shopContent
                } else {
                    loginPrompt
                }
            }
            .navigationTitle("Shop")
            .sheet(isPresented: $showLoginView) {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
    
    private var shopContent: some View {
        // MARK: - Shop Content
        // TODO: Replace this Text view with your actual shop content
        // This is where you should implement your shop's main interface
        // Consider adding:
        // - A list or grid of products
        // - Category filters
        // - Search functionality
        // - Add to cart buttons
        // Example:
        // ScrollView {
        //     LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
        //         ForEach(yourProductsArray) { product in
        //             ProductView(product: product)
        //         }
        //     }
        // }
        Text("Welcome to the Shop!")
    }
    
    private var loginPrompt: some View {
        VStack {
            Text("Please log in to view the shop")
                .font(.headline)
                .padding()
            
            Button("Login") {
                showLoginView = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ShopView(authViewModel: AuthenticationView())
}
