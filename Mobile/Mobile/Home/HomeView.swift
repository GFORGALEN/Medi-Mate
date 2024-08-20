import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isShowingCamera = false
    @FocusState private var isSearchFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    titleView
                    searchBar
                    contentArea
                }
                .navigationDestination(isPresented: $viewModel.navigateToResults) {
                                ResultsView(viewModel: viewModel)
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
                
                // 加载遮罩层
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            CustomLoadingView()
                        )
                        .allowsHitTesting(true)
                }
            }
        }
        .disabled(viewModel.isLoading)
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
                .onSubmit {
                    performSearch()
                }
            
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
            EmptyView()
        }
    }

    private func performSearch() {
        viewModel.performSearch()
    }
}
