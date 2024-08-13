import SwiftUI
import UIKit

struct HomeView: View {
    @State private var text: String = ""
    @State private var image: UIImage?
    @State private var imageFileSize: String = ""
    @State private var isShowingCamera = false
    @StateObject private var searchModel = SearchViewModel()
    
    var body: some View {
        VStack {
            Text("Medimate")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(Color("bar"))
                .padding(.top, 50)
            
            
            HStack {
                TextField("Type something...", text: $searchModel.searchText)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                
                Button(action: {
                    Task {
                        await searchModel.search()
                    }
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



#Preview {
    HomeView()
}
