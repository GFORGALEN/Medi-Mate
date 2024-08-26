import SwiftUI

struct SearchResultsContainer: View {
    @ObservedObject var viewModel: HomeVM
    @AppStorage("isCareMode") private var isOlderMode = false

    var body: some View {
        Group {
            if isOlderMode {
                //OlderModeResultsView(HomeVM: viewModel)
            } else {
                ResultsView(HomeVM: viewModel)
            }
        }
    }
}
