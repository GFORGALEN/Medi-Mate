import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationView()
    @StateObject private var tabBarManager = TabBarManager()
    @AppStorage("isCareMode") private var isOlderMode = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("background").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                switch tabBarManager.selectedIndex {
                case 0:
                    HomeView()
                case 1:
                    CardView()
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
        .environmentObject(authViewModel)
        .onChange(of: authViewModel.isLoginSuccessed) { oldValue, newValue in
            if newValue {
                tabBarManager.selectedIndex = 0
            }
        }
        .environment(\.fontSizeMultiplier, isOlderMode ? 1.25 : 1.0)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
