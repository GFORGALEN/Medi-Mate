import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationView()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("Shop")
                .tabItem {
                    Label("Shop", systemImage: "bag.fill")
                }
            Text("Cart")
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
            Group {
                if authViewModel.isLoginSuccessed {
                    AccountView(authViewModel: authViewModel)
                } else {
                    LoginView(authViewModel: authViewModel)
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
