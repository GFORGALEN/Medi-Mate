import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeVM()
    @State private var isShowingCamera = false
    @FocusState private var isSearchFieldFocused: Bool
    @AppStorage("isCareMode") private var isCareMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    titleView
                    searchArea
                    modeToggleButton
                }
                .navigationDestination(isPresented: $viewModel.navigateToResults) {
                    SearchResultsContainer(viewModel: viewModel)
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
                
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            CustomLoadingView()
                        )
                        .allowsHitTesting(true)                    //阻止用户和遮罩层下的ui元素互动
                }
            }
            

        }
        .disabled(viewModel.isLoading)
        .animation(.easeInOut, value: isCareMode)
        .environment(\.fontSizeMultiplier, isCareMode ? 1.25 : 1.0)
    }

    private var modeToggleButton: some View {
        Button(action: {
            isCareMode.toggle()
        }) {
            Image(systemName: isCareMode ? "person.fill.checkmark" : "person")
            Text("Care Mode")
                .bold()

        }
        .padding(20)
        .background(isCareMode ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .foregroundColor(.primary)
        .scalableFont(size: isCareMode ? 20 : 16, weight: .medium)
    }


    private var titleView: some View {
        Text("Medimate")
            .scalableFont(size: 60, weight: .bold, design: .rounded)
            .foregroundColor(Color("bar"))
            .padding(.top, 50)
    }

    private var searchArea: some View {
            VStack(spacing: isCareMode ? 30 : 0) {
                HStack {
                    TextField("Type something...", text: $viewModel.searchText)
                        .scalableFont(size: isCareMode ? 30 : 20, weight: .bold, design: .monospaced)
                        .focused($isSearchFieldFocused)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !isCareMode {
                        searchButton
                        cameraButton
                    }
                }
                .padding(isCareMode ? 25 : 15)
                .frame(height: isCareMode ? 120 : 60)  // Increased height for Older Mode
                .overlay(
                    RoundedRectangle(cornerRadius: isCareMode ? 30 : 20)
                        .stroke(Color.black, lineWidth: isCareMode ? 6 : 4)
                )
                
                if isCareMode {
                    HStack(spacing: 30) {
                        searchButton
                        cameraButton
                    }
                }
            }
            .padding()
            .padding(.bottom, isCareMode ? 30 : 200)
        }

        private var searchButton: some View {
            Button(action: performSearch) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isCareMode ? 75 : 30, height: isCareMode ? 75 : 30)
                    .bold()
                    .foregroundColor(isCareMode ? .white : .black)
            }
            .frame(width: isCareMode ? 120 : 50, height: isCareMode ? 120 : 50)
            .background(isCareMode ? Color.blue : Color.clear)
            .cornerRadius(isCareMode ? 30 : 0)
        }

        private var cameraButton: some View {
            Button(action: { isShowingCamera = true }) {
                Image(.cameraRetroSolid)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isCareMode ? 75 : 30, height: isCareMode ? 75 : 30)
            }
            .frame(width: isCareMode ? 120 : 50, height: isCareMode ? 120 : 50)
            .background(isCareMode ? Color.green : Color.white)
            .cornerRadius(isCareMode ? 30 : 10)
        }

    private func performSearch() {
        viewModel.performSearch()
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
