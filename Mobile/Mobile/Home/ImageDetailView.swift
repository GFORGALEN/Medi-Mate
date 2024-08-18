import SwiftUI

struct DetailRow: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Text(content)
                .font(.body)
        }
    }
}

struct ImageDetailView: View {
    let medication: Medication
    @State private var navigateToResults = false
    @StateObject private var viewModel = HomeViewModel()
    @State private var showTabBar = true

    var body: some View {
        NavigationStack {

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(uiImage: medication.image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text(medication.description?.name ?? "Non")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    DetailRow(title: "Description", content: medication.description?.description ?? "Non")
                    DetailRow(title: "CommonUse", content: medication.description?.commonUse ?? "Non")
                    DetailRow(title: "SideEffects", content: medication.description?.sideEffects ?? "Non")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                
                Button(action: {
                    viewModel.searchText = medication.description?.name ?? ""
                    viewModel.performSearch()
                    navigateToResults = true
                }, label: {
                    Text("Search Similar Products")
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color("bar"))
                        .foregroundColor(.white)
                        .cornerRadius(60)
                })
            }
            .padding()
        }
        .navigationDestination(isPresented: $navigateToResults) {
            ProductSearchResultsView(viewModel: viewModel)
                .onAppear { showTabBar = false }
                .onDisappear { showTabBar = true }
        }
            
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(medication: sampleMedication)
    }
    
    static var sampleMedication: Medication {
        // Creating a sample image
        let sampleImage = UIImage(systemName: "capsule.fill")!
        
        // Creating sample medication information
        let sampleInfo = MedicationInfo(
            name: "fish",
            description: "Used to treat mild to moderate pain and to reduce fever.",
            commonUse: "Pain relief, fever reduction",
            sideEffects: "Rarely causes side effects when used in recommended amounts."
        )
        
        return Medication(image: sampleImage, description: sampleInfo)
    }
}
