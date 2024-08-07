import SwiftUI

struct ContentView: View {
    @State private var errorMessage: String = ""
    @State private var isAuthenticated: Bool = false  // Tracks the authentication status

    var body: some View {
        TabView {
            // Home View Tab
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            // Shop View Tab
            Text("Shop")
                .tabItem {
                    Label("Shop", systemImage: "bag.fill")
                }
            
            // Cart View Tab
            Text("Cart")
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
            LoginView()
            
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
        }
            
//            
        .toolbarBackground(.visible, for: .tabBar)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
