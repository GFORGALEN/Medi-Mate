import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var isShowingCamera = false
    @State private var navigateToResults = false
    @Binding var showTabBar: Bool

    var body: some View {
        NavigationStack {
            VStack {
                titleView
                searchBar
                contentArea
            }
            .navigationDestination(isPresented: $navigateToResults) {
                ProductSearchResultsView(viewModel: viewModel)
                    .onAppear { showTabBar = false }
                    .onDisappear { showTabBar = true }
            }
            .sheet(isPresented: $isShowingCamera) {
                ImagePicker(image: $viewModel.image, sourceType: .camera)
            }
            .sheet(isPresented: $viewModel.isFinished) {
                ImageDetailView(medication: Medication(
                    image: viewModel.image,
                    description: viewModel.medicationInfo
                ))
            }
            .onChange(of: viewModel.image) { oldImage, newImage in
                if let newImage = newImage {
                    Task {
                        await viewModel.uploadImage(newImage)
                    }
                }
            }
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
        Task {
             viewModel.search()
        }
        navigateToResults = true
    }
}
