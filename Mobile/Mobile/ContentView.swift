import SwiftUI
import AnimatedTabBar

struct ContentView: View {
    
    @State private var selectedIndex = 0
    @StateObject private var authViewModel = AuthenticationView()  // Corrected for ViewModel usage

    let icons = ["house", "bag", "star", "person.crop.circle"]  // Icons for each tab

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("background").edgesIgnoringSafeArea(.all)
            
            // Main content switching based on selected index
            VStack {
                Spacer()
                switch selectedIndex {
                case 0:
                    HomeView()  // Assuming HomeView exists
                case 1:
                    Text("Shop")  // Placeholder for Shop content
                case 2:
                    Text("Cart")  // Placeholder for Cart content
                case 3:
                    accountOrLoginView()  // Dynamically determines view based on login status
                default:
                    Text("Unknown Content")  // Fallback for undefined tabs
                }
                Spacer()
            }
            
            
            // AnimatedTabBar with custom WiggleButton for each tab
            AnimatedTabBar(selectedIndex: $selectedIndex, views: icons.indices.map { index in
                wiggleButtonAt(index)
            })
            .barColor(Color("bar"))
            .cornerRadius(30)
            .selectedColor(.black)
            .unselectedColor(Color("unSelect"))
            .ballColor(Color("ball"))
            .verticalPadding(20)
            .ballTrajectory(.teleport)
            .ballAnimation(.easeOut(duration: 0.2))
            
            
            
           
            
            
            
            
        }
    }
    
   

    // Helper function to generate each WiggleButton with appropriate settings
    func wiggleButtonAt(_ index: Int) -> some View {
        WiggleButton(image: Image(systemName: icons[index]), maskImage: Image(systemName: "\(icons[index]).fill"), isSelected: index == selectedIndex)
            .scaleEffect(1.2)
            .onTapGesture {
                selectedIndex = index  // Update selected index when tab is tapped
            }
    }

    // Dynamic view for account/login based on authentication status
    @ViewBuilder
    private func accountOrLoginView() -> some View {
        if authViewModel.isLoginSuccessed {
            AccountView(authViewModel: authViewModel)  // Display account view if logged in
        } else {
            LoginView(authViewModel: authViewModel)  // Display login view if not logged in
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


