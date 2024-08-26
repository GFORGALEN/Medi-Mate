import SwiftUI

struct ComparisonView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    let productIds: [String]
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    CustomLoadingView()
                } else if viewModel.comparisons.isEmpty {
                    EmptyStateView()
                } else {
                    SideBySideComparisonView(comparisons: viewModel.comparisons)
                }
            }
            .navigationTitle("Product Comparison")
        }
        .onAppear {
            viewModel.fetchComparisons(productIds: productIds)
        }
    }
}

struct SideBySideComparisonView: View {
    let comparisons: [Comparison]
    let attributes: [(String, (Comparison) -> AttributeContent)] = [
        ("Image", { .image($0.imageSrc) }),
        ("Name", { .text($0.productName) }),
        ("Price", { .text($0.productPrice) }),
        ("Common Use", { .text($0.commonUse) }),
        ("Warnings", { .text($0.warnings) }),
    ]
    
    var body: some View {
        ScrollView([.vertical, .horizontal], showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    AttributeHeaderColumn()
                    ProductColumnsView(comparisons: comparisons)
                }
                DifferenceButtonView(comparisons: comparisons)
                Spacer().frame(height: 50)
            }
        }
    }
}

struct DifferenceButtonView: View {
    let comparisons: [Comparison]
    @State private var showDifferences = false
    
    var body: some View {
        Button(action: {
            showDifferences = true
        }) {
            HStack {
                Image(.robot)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                Text("Tell me difference")
                    .font(.title3)
                    .bold()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 300)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
            )
        }
        .padding()
        .sheet(isPresented: $showDifferences) {
            DifferencePopupView(comparisons: comparisons)
        }
    }
}

struct DifferencePopupView: View {
    let comparisons: [Comparison]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(comparisons, id: \.productId) { comparison in
                VStack(alignment: .leading) {
                    Text(comparison.productName)
                        .font(.title2)
                    Text(comparison.difference)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Differences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AttributeHeaderColumn: View {
    let attributes = ["Image", "Name", "Price", "Common Use", "Warnings"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(attributes, id: \.self) { attribute in
                AttributeCell(content: .text(attribute), isHeader: true)
            }
        }
    }
}

struct ProductColumnsView: View {
    let comparisons: [Comparison]
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(comparisons, id: \.productId) { product in
                ProductColumn(product: product)
            }
        }
    }
}

struct ProductColumn: View {
    let product: Comparison
    let attributes: [(String, (Comparison) -> AttributeContent)] = [
        ("Image", { .image($0.imageSrc) }),
        ("Name", { .text($0.productName) }),
        ("Price", { .text($0.productPrice) }),
        ("Common Use", { .text($0.commonUse) }),
        ("Warnings", { .text($0.warnings) }),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(attributes, id: \.0) { _, getValue in
                AttributeCell(content: getValue(product), isHeader: false)
            }
        }
    }
}

enum AttributeContent {
    case text(String)
    case image(String)
}

struct AttributeCell: View {
    let content: AttributeContent
    let isHeader: Bool
    @State private var showFullContent = false
    
    var body: some View {
        Group {
            switch content {
            case .text(let text):
                TextAttributeCell(text: text, isHeader: isHeader, showFullContent: $showFullContent)
            case .image(let imageSrc):
                ProductImage(imageSrc: imageSrc)
            }
        }
        .sheet(isPresented: $showFullContent) {
            FullContentView(content: content)
        }
    }
}

struct TextAttributeCell: View {
    let text: String
    let isHeader: Bool
    @Binding var showFullContent: Bool
    
    var body: some View {
        Text(text)
            .padding(10)
            .frame(width: isHeader ? 100 : 150, height: 100, alignment: .topLeading)
            .background(isHeader ? Color.secondary.opacity(0.2) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
            )
            .onTapGesture {
                if !isHeader {
                    showFullContent = true
                }
            }
    }
}

struct ProductImage: View {
    let imageSrc: String
    @State private var showFullImage = false
    
    var body: some View {
        AsyncImage(url: URL(string: imageSrc)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 150, height: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
        )
        .onTapGesture {
            showFullImage = true
        }
        .sheet(isPresented: $showFullImage) {
            FullContentView(content: .image(imageSrc))
        }
    }
}

struct FullContentView: View {
    let content: AttributeContent
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                switch content {
                case .image(let imageSrc):
                    AsyncImage(url: URL(string: imageSrc)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                case .text(let text):
                    ScrollView {
                        Text(text)
                            .padding()
                            .font(.title2)
                    }
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("No comparison data available")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}
