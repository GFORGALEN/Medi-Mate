//
//  ProductDetailView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//
import AVFoundation

import SwiftUI

struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailsVM
    @State private var selectedSection: String?
    @State private var isStoreSelectionPresented = false
    @State private var selectedStore: String?
    @State private var locationData: ProductLocationData?
    @State private var isShowingLocationView = false
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    
    init(productId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailsVM(productId: productId))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    switch viewModel.state {
                    case .idle, .loading:
                        ProgressView("Loading...")
                            .scalableFont(size: 18)
                    case .loaded(let details):
                        ProductDetailsContent(
                            details: details,
                            viewModel: viewModel,
                            selectedSection: $selectedSection,
                            isStoreSelectionPresented: $isStoreSelectionPresented,
                            selectedStore: $selectedStore,
                            locationData: $locationData,
                            isShowingLocationView: $isShowingLocationView
                        )
                    case .error(let error):
                        ErrorView(error: error, retryAction: { Task { await viewModel.loadProductDetails() } })
                    }
                }
                
                if isStoreSelectionPresented {
                    StoreSelectionPopup(
                        isPresented: $isStoreSelectionPresented,
                        selectedStore: $selectedStore,
                        productId: viewModel.productId
                    ) { data in
                        locationData = data
                        isShowingLocationView = true
                    }
                }
            }
            .navigationTitle("Product Details")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingLocationView) {
                if let data = locationData {
                    NavigationStack {
                        LocationView(location: StoreLocation(rawValue: data.shelfNumber) ?? .a, productLocation: data)
                            .navigationBarItems(leading: Button("Back") {
                                isShowingLocationView = false
                            })
                    }
                }
            }
        }
        .task {
            await viewModel.loadProductDetails()
        }
    }
}

struct ProductDetailsContent: View {
    let details: ProductDetails
    @ObservedObject var viewModel: ProductDetailsVM
    @Binding var selectedSection: String?
    @Binding var isStoreSelectionPresented: Bool
    @Binding var selectedStore: String?
    @Binding var locationData: ProductLocationData?
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    @Binding var isShowingLocationView: Bool

    
    var body: some View {
        ScrollView {
            VStack(spacing: isOlderMode ? 30 : 20) {
                headerSection
                summarySection
                readAloudSection
                contentSections
                Spacer()
                    .frame(height: 40)
            }
            .padding(isOlderMode ? 20 : 15)
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private var headerSection: some View {
        VStack(spacing: isOlderMode ? 20 : 15) {
            AsyncImage(url: URL(string: details.imageSrc)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fit)
                case .failure:
                    Image(systemName: "photo").foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: isOlderMode ? 250 : 200)
            .clipShape(RoundedRectangle(cornerRadius: isOlderMode ? 15 : 10))
            .shadow(radius: isOlderMode ? 8 : 5)
            
            Text(details.productName)
                .scalableFont(size: isOlderMode ? 28 : 22, weight: .bold)
                .multilineTextAlignment(.center)
            
            Text("Price: \(details.productPrice)")
                .scalableFont(size: isOlderMode ? 24 : 18, weight: .semibold)
                .foregroundColor(.secondary)
            
            Text("Manufacturer: \(details.manufacturerName)")
                .scalableFont(size: isOlderMode ? 20 : 16)
                .foregroundColor(.secondary)
            
            Button(action: {
                            isStoreSelectionPresented = true
                        }) {
                            Text("Select Store")
                                .scalableFont(size: isOlderMode ? 20 : 16, weight: .semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(isOlderMode ? 15 : 10)
                        }
                        .padding(.top, isOlderMode ? 15 : 10)
                    }
                }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: isOlderMode ? 15 : 10) {
            Text("AI Generated Summary")
                .scalableFont(size: isOlderMode ? 26 : 20, weight: .bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text(details.summary)
                .scalableFont(size: isOlderMode ? 20 : 16)
                .padding()
                .background(
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4), Color.red.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        RoundedRectangle(cornerRadius: isOlderMode ? 15 : 10)
                            .stroke(Color.white.opacity(0.2), lineWidth: isOlderMode ? 3 : 2)
                    }
                )
                .foregroundColor(.white)
                .cornerRadius(isOlderMode ? 15 : 10)
                .shadow(color: Color.black.opacity(0.1), radius: isOlderMode ? 8 : 5, x: 0, y: 5)
            
            HStack {
                Text("Powered by AI")
                    .scalableFont(size: isOlderMode ? 16 : 12)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Link("Disclaimer", destination: URL(string: "https://bevel-terrier-8ea.notion.site/Disclaimer-for-Medimat-07344876198445109e7f671666fb3a54")!)
                    .scalableFont(size: isOlderMode ? 16 : 12)
                    .foregroundColor(.blue)
            }
            .padding(.top, isOlderMode ? 10 : 5)
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(isOlderMode ? 20 : 15)
    }
    
    private var readAloudSection: some View {
        VStack(spacing: isOlderMode ? 15 : 10) {
            Button(action: {
                viewModel.toggleSpeaking()
            }) {
                HStack {
                    Image(systemName: viewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: isOlderMode ? 30 : 24))
                    Text(viewModel.isSpeaking ? "Stop Reading" : "Read Aloud")
                        .scalableFont(size: isOlderMode ? 24 : 20, weight: .semibold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: isOlderMode ? 70 : 50)
                .background(viewModel.isSpeaking ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(isOlderMode ? 15 : 10)
            }
            .buttonStyle(PlainButtonStyle())
            
            if viewModel.isSpeaking {
                HStack {
                    Text("Speed:")
                        .scalableFont(size: isOlderMode ? 20 : 16)
                    ForEach(["Normal", "Fast", "Very Fast"], id: \.self) { speed in
                        Button(speed) {
                            viewModel.updateSpeechRate(forSpeed: speed)
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.currentSpeedLabel == speed ? .green : .blue)
                        .scalableFont(size: isOlderMode ? 18 : 14)
                    }
                }
            }
        }
    }
    
    private var contentSections: some View {
        VStack(alignment: .leading, spacing: isOlderMode ? 25 : 20) {
            ForEach([
                ("General Information", details.generalInformation ?? "Not Available"),
                ("Warnings", details.warnings ?? "Not Available"),
                ("Common Use", details.commonUse ?? "Not Available"),
                ("Ingredients", details.ingredients ?? "Not Available"),
                ("Directions", details.directions ?? "Not Available")
            ], id: \.0) { title, content in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { selectedSection == title },
                        set: { if $0 { selectedSection = title } else { selectedSection = nil } }
                    )
                ) {
                    Text(content)
                        .scalableFont(size: isOlderMode ? 18 : 16)
                        .padding(.vertical)
                } label: {
                    Text(title)
                        .scalableFont(size: isOlderMode ? 22 : 18, weight: .semibold)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(isOlderMode ? 15 : 10)
            }
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    @AppStorage("isCareMode") private var isOlderMode = false
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
                .scalableFont(size: isOlderMode ? 20 : 16)
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry", action: retryAction)
                .scalableFont(size: isOlderMode ? 22 : 18, weight: .semibold)
                .padding()
                .frame(height: isOlderMode ? 60 : 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(isOlderMode ? 15 : 10)
        }
    }
}
