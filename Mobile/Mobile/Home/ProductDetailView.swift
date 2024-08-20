//
//  ProductDetailView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI
import AVFoundation

struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailsViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var selectedSection: String?
    
    init(productId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(productId: productId))
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading...")
            case .loaded(let details):
                ProductDetailsContent(details: details, viewModel: viewModel, selectedSection: $selectedSection)
            case .error(let error):
                ErrorView(error: error, retryAction: { Task { await viewModel.loadProductDetails() } })
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProductDetails()
        }
        .onAppear {
            tabBarManager.isVisible = false
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if tabBarManager.isVisible == false {
                    tabBarManager.isVisible = true
                }
            }
        }
    }
}

struct ProductDetailsContent: View {
    let details: ProductDetails
    @ObservedObject var viewModel: ProductDetailsViewModel
    @Binding var selectedSection: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                summarySection
                readAloudSection
                contentSections
            }
            .padding()
        }
        .background(Color(UIColor.systemBackground))
    }
    
    private var headerSection: some View {
        VStack(spacing: 15) {
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
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
            
            Text(details.productName)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Price: \(details.productPrice)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Manufacturer: \(details.manufacturerName)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("AI Generated Summary")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                        )
                    )
                    
                    Text(details.summary)
                        .font(.body)
                        .padding()
                        .background(
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                            }
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    HStack {
                            Text("Powered by AI")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Link("Disclaimer", destination: URL(string: "https://bevel-terrier-8ea.notion.site/Disclaimer-for-Medimat-07344876198445109e7f671666fb3a54")!)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 5)
                }
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(15)
    }
    
    private var readAloudSection: some View {
        VStack(spacing: 10) {
            Button(action: {
                viewModel.toggleSpeaking()
            }) {
                HStack {
                    Image(systemName: viewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                    Text(viewModel.isSpeaking ? "Stop Reading" : "Read Aloud")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.isSpeaking ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            
            HStack {
                Text("Speed:")
                ForEach(["Normal", "Fast", "Very Fast"], id: \.self) { speed in
                    Button(speed) {
                        viewModel.updateSpeechRate(forSpeed: speed)
                    }
                    .buttonStyle(.bordered)
                    .tint(viewModel.currentSpeedLabel == speed ? .green : .blue)
                }
            }
        }
    }
    
    private var contentSections: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach([
                ("General Information", details.generalInformation),
                ("Warnings", details.warnings),
                ("Common Use", details.commonUse),
                ("Ingredients", details.ingredients),
                ("Directions", details.directions)
            ], id: \.0) { title, content in
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { selectedSection == title },
                        set: { if $0 { selectedSection = title } else { selectedSection = nil } }
                    )
                ) {
                    Text(content)
                        .font(.body)
                        .padding(.vertical)
                } label: {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error: \(error.localizedDescription)")
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry", action: retryAction)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

extension ProductDetailsViewModel {
    func updateSpeechRate(forSpeed speed: String) {
        switch speed {
        case "Normal":
            updateSpeechRate(AVSpeechUtteranceDefaultSpeechRate)
        case "Fast":
            updateSpeechRate(AVSpeechUtteranceDefaultSpeechRate * 1.25)
        case "Very Fast":
            updateSpeechRate(AVSpeechUtteranceDefaultSpeechRate * 1.5)
        default:
            break
        }
    }
    
    var currentSpeedLabel: String {
        if speechRate == AVSpeechUtteranceDefaultSpeechRate {
            return "Normal"
        } else if speechRate == AVSpeechUtteranceDefaultSpeechRate * 1.25 {
            return "Fast"
        } else if speechRate == AVSpeechUtteranceDefaultSpeechRate * 1.5 {
            return "Very Fast"
        } else {
            return "Custom"
        }
    }
}
