import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isShowingCamera = false
    @FocusState private var isSearchFieldFocused: Bool
    @AppStorage("isOlderMode") private var isOlderMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    titleView
                    searchArea
//                    contentArea
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
                        .allowsHitTesting(true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    modeToggleButton
                }
            }
        }
        .disabled(viewModel.isLoading)
        .animation(.easeInOut, value: isOlderMode)
        .environment(\.fontSizeMultiplier, isOlderMode ? 1.25 : 1.0)
    }

    private var modeToggleButton: some View {
        Button(action: {
            isOlderMode.toggle()
        }) {
            Image(systemName: isOlderMode ? "textformat.size.larger" : "textformat.size")
                .foregroundColor(.primary)
                .font(.system(size: isOlderMode ? 24 : 20))
                .frame(width: isOlderMode ? 44 : 40, height: isOlderMode ? 44 : 40)
        }
    }

    private var titleView: some View {
        Text("Medimate")
            .scalableFont(size: 60, weight: .bold, design: .rounded)
            .foregroundColor(Color("bar"))
            .padding(.top, 50)
    }

    private var searchArea: some View {
            VStack(spacing: isOlderMode ? 30 : 0) {
                HStack {
                    TextField("Type something...", text: $viewModel.searchText)
                        .scalableFont(size: isOlderMode ? 30 : 20, weight: .bold, design: .monospaced)
                        .focused($isSearchFieldFocused)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !isOlderMode {
                        searchButton
                        cameraButton
                    }
                }
                .padding(isOlderMode ? 25 : 15)
                .frame(height: isOlderMode ? 120 : 60)  // Increased height for Older Mode
                .overlay(
                    RoundedRectangle(cornerRadius: isOlderMode ? 30 : 20)
                        .stroke(Color.black, lineWidth: isOlderMode ? 6 : 4)
                )
                
                if isOlderMode {
                    HStack(spacing: 30) {
                        searchButton
                        cameraButton
                    }
                }
            }
            .padding()
            .padding(.bottom, isOlderMode ? 30 : 200)
        }

        private var searchButton: some View {
            Button(action: performSearch) {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isOlderMode ? 75 : 30, height: isOlderMode ? 75 : 30)
                    .bold()
                    .foregroundColor(isOlderMode ? .white : .black)
            }
            .frame(width: isOlderMode ? 120 : 50, height: isOlderMode ? 120 : 50)
            .background(isOlderMode ? Color.blue : Color.clear)
            .cornerRadius(isOlderMode ? 30 : 0)
        }

        private var cameraButton: some View {
            Button(action: { isShowingCamera = true }) {
                Image(.cameraRetroSolid)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isOlderMode ? 75 : 30, height: isOlderMode ? 75 : 30)
            }
            .frame(width: isOlderMode ? 120 : 50, height: isOlderMode ? 120 : 50)
            .background(isOlderMode ? Color.green : Color.white)
            .cornerRadius(isOlderMode ? 30 : 10)
        }
//    private var contentArea: some View {
//        VStack {
//            Text("Main Content Area")
//                .scalableFont(size: 20)
//            
//            Text("Current Mode: \(isOlderMode ? "Older" : "Normal")")
//                .scalableFont(size: 16)
//                .padding()
//        }
//    }

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
