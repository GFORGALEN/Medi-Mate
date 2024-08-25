import SwiftUI

struct ComparisonView: View {
    @ObservedObject var viewModel: ComparisonViewModel
    let productIds: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Product Comparison")
                .font(.headline)
                .padding()
            
            if viewModel.isLoading {
                CustomLoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.comparisons.isEmpty {
                Text("No comparison data available")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                SideBySideComparisonView(comparisons: viewModel.comparisons)
            }
        }
        .onAppear {
            viewModel.fetchComparisons(productIds: productIds)
        }
    }
}

struct SideBySideComparisonView: View {
    let comparisons: [Comparison]
    let attributes: [(String, (Comparison) -> String)] = [
        ("Image", { _ in "" }),
        ("Name", { $0.productName }),
        ("Price", { $0.productPrice }),
        ("Common Use", { $0.commonUse }),
        ("Warnings", { $0.warnings }),
        ("Difference", { $0.difference })
    ]
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(attributes, id: \.0) { attribute, _ in
                        AttributeCell(text: attribute, isHeader: true)
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(comparisons, id: \.productId) { product in
                            VStack(spacing: 0) {
                                ForEach(attributes, id: \.0) { _, getValue in
                                    if getValue(product) == "" {
                                        ProductImage(imageSrc: product.imageSrc)
                                    } else {
                                        AttributeCell(text: getValue(product), isHeader: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AttributeCell: View {
    let text: String
    let isHeader: Bool
    @State private var showFullContent = false
    
    var body: some View {
        Text(text)
            .padding(10)
            .frame(width: isHeader ? 100 : 150, height: 100, alignment: .topLeading)
            .background(isHeader ? Color.gray.opacity(0.2) : Color.white)
            .border(Color.gray.opacity(0.5), width: 0.5)
            .onTapGesture {
                if !isHeader {
                    showFullContent = true
                }
            }
            .sheet(isPresented: $showFullContent) {
                FullContentView(content: text, isImage: false)
            }
    }
}

struct ProductImage: View {
    let imageSrc: String
    @State private var showFullImage = false
    
    var body: some View {
        AsyncImage(url: URL(string: imageSrc)) { image in
            image.resizable().aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 150, height: 100)
        .border(Color.gray.opacity(0.5), width: 0.5)
        .onTapGesture {
            showFullImage = true
        }
        .sheet(isPresented: $showFullImage) {
            FullContentView(content: imageSrc, isImage: true)
        }
    }
}


struct FullContentView: View {
    let content: String
    let isImage: Bool
    
    var body: some View {
        VStack {
            if isImage {
                AsyncImage(url: URL(string: content)) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            } else {
                ScrollView {
                    Text(content)
                        .padding()
                        .font(.title)
                }
            }
            
            Button("Close") {
                // This will be handled by the presenting view
            }
            .padding()
        }
    }
}
