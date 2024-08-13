import SwiftUI
import UIKit

struct HomeView: View {
    @State private var text: String = ""
    @State private var image: UIImage?
    @State private var imageFileSize: String = ""
    @State private var isShowingCamera = false
    @StateObject private var searchModel = SearchViewModel()
    @State private var navigateToResults = false
    @Binding var showTabBar: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("Medimate")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(Color("bar"))
                    .padding(.top, 50)
                
                Text("result: \(navigateToResults)")
                
                HStack {
                    TextField("Type something...", text: $searchModel.searchText)
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                    
                    Button(action: {
                        navigateToResults = true
                        print(navigateToResults)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .bold()
                            .padding(.trailing, 10)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        self.isShowingCamera = true
                    }) {
                        Image(.cameraRetroSolid)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 4)
                )
                .padding(.bottom, 200)
                .padding()
                
                if searchModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(5)
                        .frame(height: 200)
                }
            }
            .navigationDestination(isPresented: $navigateToResults) {
                ProductSearchResultsView(products: sampleProducts)
                    .onAppear { showTabBar = false }
                    .onDisappear { showTabBar = true }
            }
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(image: self.$image, sourceType: .camera)
            }
            .sheet(isPresented: $searchModel.isFinished) {
                DetailView(
                    medication: Medication(
                        image: self.image,
                        description: searchModel.medicationInfo)
                )
            }
            .onChange(of: image) { oldImage, newImage in
                if let newImage = newImage {
                    Task {
                        await searchModel.uploadImage(newImage)
                    }
                }
            }
        }
    }
    
    // Sample product data remains the same
    private var sampleProducts: [Product] {
        [
            Product(id: "1", name: "iPhone 13", imageURL: "https://example.com/iphone13.jpg"),
            Product(id: "2", name: "MacBook Pro", imageURL: "https://example.com/macbookpro.jpg"),
            Product(id: "3", name: "AirPods Pro", imageURL: "https://example.com/airpodspro.jpg"),
            Product(id: "4", name: "iPad Air", imageURL: "https://example.com/ipadair.jpg"),
            Product(id: "5", name: "Apple Watch Series 7", imageURL: "https://example.com/applewatch7.jpg")
        ]
    }
}

#Preview {
    HomeView(showTabBar: .constant(true))
}
