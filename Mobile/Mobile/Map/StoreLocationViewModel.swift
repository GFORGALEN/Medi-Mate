//
//  StoreLocationViewModel.swift
//  Mobile
//
//  Created by Lykheang Taing on 14/08/2024.
//


import Foundation
import CoreLocation

struct Location: Identifiable, Codable {
    let id = UUID()
    let name_store: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LocationsData: Codable {
    let locations: [Location]
}

class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    
    init() {
        loadLocations()
    }
    
    func loadLocations() {
        guard let url = Bundle.main.url(forResource: "location", withExtension: "json") else {
            print("JSON file 'location.json' not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let locationsData = try JSONDecoder().decode(LocationsData.self, from: data)
            DispatchQueue.main.async {
                self.locations = locationsData.locations
                print("Loaded \(self.locations.count) locations")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
