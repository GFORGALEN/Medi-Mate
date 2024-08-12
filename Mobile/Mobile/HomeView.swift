import SwiftUI
import UIKit

struct HomeView: View {
    @State private var text: String = ""
    //State: property wrapper 当使用 @State 包装的值发生变化时，SwiftUI 会自动重新渲染使用该值的视图
    //private表示它只能在当前视图中使用。
    @State private var image: UIImage?
    
    @State private var isShowingCamera = false
    @State private var isShowingDetail = false

    
    @StateObject private var searchModel = SearchViewModel()
    

    var body: some View {
        VStack {
            Text("Medimate")
                .font(.largeTitle)
                .bold()

            HStack {
                TextField("Type something...", text: $searchModel.searchText)
                
                Button(action: {
                    self.isShowingDetail = true
                    Task {
                            await searchModel.uploadImage(.image)
                                        }
                }) {
                    Image(.cameraRetroSolid)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
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
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 4)
            )
            .padding(.bottom, 200)
            .padding()
            

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(image: self.$image, sourceType: .camera)
        }
        .sheet(isPresented: $isShowingDetail){
            DetailView(medication: Medication(
                image: self.image,
                description: "\(searchModel.searchResult)"
            ))
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    HomeView()
}
