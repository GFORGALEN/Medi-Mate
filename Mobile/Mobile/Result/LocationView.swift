import SwiftUI

enum StoreLocation {
    case a, b, c, d, e
}

struct LocationView: View {
    let location: StoreLocation
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Image(.store)
                .resizable()
                .scaledToFit()
            locationIcon
        }
        .frame(width: 350, height: 350)
        .border(Color.black)
        .onAppear {
            withAnimation(.linear(duration: 0.6).repeatForever()) {
                isAnimating = true
            }
        }
    }
    
    @ViewBuilder
    private var locationIcon: some View {
        Image(systemName: "arrowshape.down.fill")
            .foregroundColor(.red)
            .font(.system(size: 30))
            .position(positionForLocation(location))
            .offset(y: isAnimating ? -5 : 5)
            .animation(.easeInOut(duration: 0.6).repeatForever(), value: isAnimating)
    }
    
    private func positionForLocation(_ location: StoreLocation) -> CGPoint {
        switch location {
        case .a:
            return CGPoint(x: 85, y: 170)
        case .b:
            return CGPoint(x: 120, y: 150)
        case .c:
            return CGPoint(x: 170, y: 130)
        case .d:
            return CGPoint(x: 140, y: 210)
        case .e:
            return CGPoint(x: 200, y: 170)
        }
    }
}

#Preview {
    LocationView(location: .a)
}
