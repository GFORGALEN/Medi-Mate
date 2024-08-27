import SwiftUI
import AVFoundation

@MainActor
class ProductDetailsVM: ObservableObject {
    @Published private(set) var state: LoadingState = .idle
    @Published private(set) var productDetails: ProductDetails?
    private let networkService: NetworkServiceProtocol
    private let productId: String
    
    @Published var isSpeaking = false
    @Published var speechRate: Float = AVSpeechUtteranceDefaultSpeechRate
    private var synthesizer = AVSpeechSynthesizer()
    
    init(productId: String, networkService: NetworkServiceProtocol = NetworkService()) {
        self.productId = productId
        self.networkService = networkService
       
        setupAudioSession()
    }
    
    func loadProductDetails() async {
        state = .loading
        
        do {
            let jsonString = try await networkService.fetchProductDetails(productId: productId)
            let details = try parseProductDetails(from: jsonString)
            state = .loaded(details)
            productDetails = details  // Add this line
        } catch {
            state = .error(error)
        }
    }
    
    private func parseProductDetails(from jsonString: String) throws -> ProductDetails {
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(APIResponse<ProductDetails>.self, from: jsonData)
        
        guard response.code == 1 else {
            throw NSError(domain: "APIError", code: response.code, userInfo: [NSLocalizedDescriptionKey: response.msg ?? "Unknown error"])
        }
        
        return response.data
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
    }
    
    func updateSpeechRate(_ newRate: Float) {
        speechRate = newRate
        if isSpeaking {
            stopSpeaking()
            if let details = productDetails {
                speakProductInfo(details: details)
            }
        }
    }
    
    func toggleSpeaking() {
        if isSpeaking {
            stopSpeaking()
        } else if let details = productDetails {
            speakProductInfo(details: details)
        }
    }
    
    private func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    private func speakProductInfo(details: ProductDetails) {
        let infoToSpeak = """
        \(details.productName). Price: \(details.productPrice).
        Manufacturer: \(details.manufacturerName).
        Summary: \(details.summary)
        """
        
        let utterance = AVSpeechUtterance(string: infoToSpeak)
        
        if let voice = AVSpeechSynthesisVoice(language: "en-US") {
            utterance.voice = voice
        } else {
            print("en-US voice not available, using default voice")
        }
        
        utterance.rate = speechRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        synthesizer.speak(utterance)
        isSpeaking = true
    }
    
    enum LoadingState {
        case idle
        case loading
        case loaded(ProductDetails)
        case error(Error)
    }
    
    
}

