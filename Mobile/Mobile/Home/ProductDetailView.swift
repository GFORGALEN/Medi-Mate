//
//  ProductDetailView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/19.
//

import SwiftUI
import AVFoundation
// MARK: - Views

struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailsViewModel
    @EnvironmentObject var tabBarManager: TabBarManager

    init(productId: String) {
        _viewModel = StateObject(wrappedValue: ProductDetailsViewModel(productId: productId))
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading...")
            case .loaded(let details):
                ProductDetailsContent(details: details, viewModel: viewModel)
            case .error(let error):
                ErrorView(error: error, retryAction: { Task { await viewModel.loadProductDetails() } })
            }
        }
        .navigationTitle("Product Details")
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

// MARK: - Subviews

struct ProductDetailsContent: View {
    let details: ProductDetails
    @ObservedObject var viewModel: ProductDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(details.productName).font(.title).fontWeight(.bold)
                    Text("Price: \(details.productPrice)").font(.headline)
                    Text("Manufacturer: \(details.manufacturerName)").font(.subheadline)
                    Button(action:{
                        viewModel.toggleSpeaking()
                    }){
                        HStack{
                            Image(systemName: viewModel.isSpeaking ? "stop.circle.fill" : "speaker.wave.2.fill")
                            Text(viewModel.isSpeaking ? "Stop" : "Read Aloud")
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
                        Button("Normal") { viewModel.updateSpeechRate(AVSpeechUtteranceDefaultSpeechRate) }
                            .buttonStyle(.bordered)
                            .tint(viewModel.speechRate == AVSpeechUtteranceDefaultSpeechRate ? .green : .blue)
                        Button("Fast") { viewModel.updateSpeechRate(AVSpeechUtteranceDefaultSpeechRate * 1.25) }
                            .buttonStyle(.bordered)
                            .tint(viewModel.speechRate == AVSpeechUtteranceDefaultSpeechRate * 1.25 ? .green : .blue)
                        Button("Very Fast") { viewModel.updateSpeechRate(AVSpeechUtteranceDefaultSpeechRate * 1.5) }
                            .buttonStyle(.bordered)
                            .tint(viewModel.speechRate == AVSpeechUtteranceDefaultSpeechRate * 1.5 ? .green : .blue)
                    }
                }
                
                Divider()
                
                ForEach([
                    ("Summary", details.summary),
                    ("General Information", details.generalInformation),
                    ("Warnings", details.warnings),
                    ("Common Use", details.commonUse),
                    ("Ingredients", details.ingredients),
                    ("Directions", details.directions)
                ], id: \.0) { title, content in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(title).font(.headline)
                        Text(content).font(.body)
                    }
                }
            }
            .padding()
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

