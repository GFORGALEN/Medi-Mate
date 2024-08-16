import Foundation
import UIKit
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var medicationInfo: MedicationInfo?
    @Published var products: [Product1] = []
    @Published var totalProducts: Int = 0
    @Published var errorMessage: String?
    @Published var isFinished = false
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        setupSearchTextPublisher()
    }
    
    private func setupSearchTextPublisher() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.search()
            }
            .store(in: &cancellables)
    }
    
    func search() {
        Task {
            await performSearch()
        }
    }
    
    private func performSearch() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await networkService.textSearch(
                page: 1,
                pageSize: 10,
                productName: searchText,
                manufacture: ""
            )
            parseSearchResult(result)
        } catch {
            errorMessage = error.localizedDescription
            print("Search error: \(error)")
        }
        isLoading = false
    }
    
    private func parseSearchResult(_ jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            errorMessage = "Invalid data format"
            return
        }
        
        do {
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: jsonData)
            self.products = searchResponse.data.records
            self.totalProducts = searchResponse.data.total
        } catch {
            errorMessage = "Failed to parse data: \(error.localizedDescription)"
            print("Error parsing search result: \(error)")
        }
    }
    
    func uploadImage(_ image: UIImage) async {
        isLoading = true
        do {
            let compressedImage = compressImage(image)
            let result = try await networkService.imageSearch(image: compressedImage)
            parseImageSearchResult(result)
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }
        isLoading = false
        isFinished = true
    }
    
    private func parseImageSearchResult(_ jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            errorMessage = "Failed to convert string to data"
            return
        }
        
        do {
            let decoder = JSONDecoder()
            self.medicationInfo = try decoder.decode(MedicationInfo.self, from: jsonData)
        } catch {
            errorMessage = "Error parsing JSON: \(error)"
            print("Error parsing JSON: \(error)")
        }
    }
    
    private func compressImage(_ image: UIImage, maxFileSize: Int = 1_048_576, maxDimension: CGFloat = 512) -> UIImage {
        let resizedImage = resizeImage(image, maxDimension: maxDimension)
        var compressionQuality: CGFloat = 1.0
        var imageData = resizedImage.jpegData(compressionQuality: compressionQuality) ?? Data()
        
        while imageData.count > maxFileSize && compressionQuality > 0.1 {
            compressionQuality -= 0.1
            imageData = resizedImage.jpegData(compressionQuality: compressionQuality) ?? Data()
        }
        
        return UIImage(data: imageData) ?? image
    }
    
    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        let aspectRatio = size.width / size.height
        
        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: min(size.width, maxDimension), height: min(size.width, maxDimension) / aspectRatio)
        } else {
            newSize = CGSize(width: min(size.height, maxDimension) * aspectRatio, height: min(size.height, maxDimension))
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
