import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationView()
    @StateObject private var tabBarManager = TabBarManager()

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("background").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                switch tabBarManager.selectedIndex {
                case 0:
                    HomeView()
                case 1:
                    CartView()
                case 2:
                    NavigationView {
                        StoreLocationsView()
                    }
                case 3:
                    if authViewModel.isLoginSuccessed {
                        AccountView(authViewModel: authViewModel)
                    } else {
                        LoginView(authViewModel: authViewModel)
                    }
                default:
                    Text("Unknown Content")
                }
                Spacer()
            }
            
            CustomTabBar()
        }
        .environmentObject(tabBarManager)
        .onChange(of: authViewModel.isLoginSuccessed) { oldValue, newValue in
            if newValue {
                tabBarManager.selectedIndex = 0
            }
        }
        .ignoresSafeArea()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
