import SwiftUI
import MapKit

struct StoreLocationsView: View {
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.locations) { location in
                        NavigationLink(destination: LocationDetailView(location: location)) {
                            locationPreview(for: location, in: geo)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("MediMate Locations")
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func locationPreview(for location: Location, in geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(location.name_store)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(location.name)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            MapView(location: location)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                Text("View Details")
                    .font(.footnote)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: geometry.size.width - 32)
    }
}
