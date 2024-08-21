import SwiftUI

struct SearchResultsContainer: View {
    @ObservedObject var viewModel: HomeViewModel
    @AppStorage("isOlderMode") private var isOlderMode = false

    var body: some View {
        Group {
            if isOlderMode {
                OlderModeResultsView(viewModel: viewModel)
            } else {
                ResultsView(viewModel: viewModel)
            }
        }
    }
}
