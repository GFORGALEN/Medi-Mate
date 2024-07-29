import SwiftUI

struct ContentView: View {
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("MediMate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            HStack {
                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Button(action: {}) {
                    Image(systemName: "camera")
                }
            }
            .padding(.horizontal)
            
            
            Spacer()
            
            HStack(spacing: 50) {
                ForEach(["house", "basket", "info.circle"], id: \.self) { iconName in
                    Image(systemName: iconName)
                }
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    ContentView()
}
