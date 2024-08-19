import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isShowingCamera = false
    @Binding var showTabBar: Bool
    @FocusState private var isSearchFieldFocused: Bool



    var body: some View {
        NavigationStack {
            VStack {
                titleView
                searchBar
                contentArea
            }
            .navigationDestination(isPresented: $viewModel.navigateToResults) {
                ProductSearchResultsView(viewModel: viewModel)
                    .onAppear { 
                        showTabBar = false
                        print("Navigation to results occurred. Products count: \(viewModel.products.count)")
                    }
                    .onDisappear { showTabBar = true }
            }
            .sheet(isPresented: $isShowingCamera) {
                            ImagePicker(image: $viewModel.image, sourceType: .camera)
                                .onDisappear {
                                    if let image = viewModel.image {
                                        Task {
                                            await viewModel.uploadImage(image)
                                        }
                                    }
                                }
                        }
            .onChange(of: viewModel.image) { oldImage, newImage in
                            if newImage != nil {
                                isShowingCamera = false
                            }
                        }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        isSearchFieldFocused = false
                    }
            )
        }
    }

    private var titleView: some View {
        Text("Medimate")
            .font(.system(size: 60, weight: .bold, design: .rounded))
            .foregroundColor(Color("bar"))
            .padding(.top, 50)
    }

    private var searchBar: some View {
        HStack {
            TextField("Type something...", text: $viewModel.searchText)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .focused($isSearchFieldFocused)


            
            Button(action: performSearch) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .bold()
                    .padding(.trailing, 10)
                    .foregroundColor(.black)
            }
            
            Button(action: { isShowingCamera = true }) {
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
    }

    private var contentArea: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(5)
                    .frame(height: 200)
            }
        }
    }

    private func performSearch() {
        viewModel.performSearch()
    }
}
