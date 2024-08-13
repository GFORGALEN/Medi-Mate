import SwiftUI
import AnimatedTabBar

struct ContentView: View {
    @State private var selectedIndex = 0
    @StateObject private var authViewModel = AuthenticationView()


    let icons = ["house", "bag", "star", "person.crop.circle"]  // Icons for each tab

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("background").edgesIgnoringSafeArea(.all)
            
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
                    if authViewModel.isLoginSuccessed {
                        AccountView(authViewModel: authViewModel)
                    } else {
                        LoginView(authViewModel: authViewModel)
                    }
                default:
                    Text("Unknown Content")  // Fallback for undefined tabs
                }
                Spacer()
            }
            
            // AnimatedTabBar
            HStack {
                Spacer(minLength: 20) // Left padding
                AnimatedTabBar(selectedIndex: $selectedIndex, views: icons.indices.map { index in
                    wiggleButtonAt(index)
                })
                .barColor(Color("bar"))
                .cornerRadius(30)
                .selectedColor(Color("select"))
                .unselectedColor(Color("unSelect"))
                .ballColor(Color("bar"))
                .verticalPadding(20)
                .ballTrajectory(.parabolic)
                .ballAnimation(.easeOut(duration: 0.4))
                Spacer(minLength: 20) // Right padding
            }
            .padding(.bottom, 20)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .onChange(of: authViewModel.isLoginSuccessed) { oldValue, newValue in
            if newValue {
                selectedIndex = 0  // Set to home page when login succeeds
            }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
