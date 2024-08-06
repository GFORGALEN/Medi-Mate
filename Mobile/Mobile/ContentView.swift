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
            
            // Login and Account Management Tab
            Group {
                if isAuthenticated {
                    // Show Logout option
                    VStack {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Hello, world!")
                        
                        Button {
                            Task {
                                do {
                                    try await AuthenticationView().logout()
                                    isAuthenticated = false  // Update authentication status on logout
                                } catch let error {
                                    errorMessage = error.localizedDescription
                                }
                            }
                        } label: {
                            Text("Log Out").padding(8)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding()
                } else {
                    // Show Login View
                    LoginView(isAuthenticated: $isAuthenticated)  // Pass isAuthenticated as a Binding
                }
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle")
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
