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
                .font(.largeTitle)
                .bold()

            HStack {
                TextField("Type something...", text: $searchModel.searchText)
                
                
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
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2)
                .padding()
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
    
    private func compressAndSetImage(_ originalImage: UIImage) -> UIImage{
        let maxFileSize = 1048576 // 1MB in bytes
        let maxDimension: CGFloat = 512 // Max width or height
        
        // Resize the image
        let resizedImage = resizeImage(originalImage, maxDimension: maxDimension)
        
        var compressionQuality: CGFloat = 1.0
        var imageData = resizedImage.jpegData(compressionQuality: compressionQuality)!
        
        // Reduce quality until file size is less than 1MB
        while imageData.count > maxFileSize && compressionQuality > 0.1 {
            compressionQuality -= 0.1
            if let data = resizedImage.jpegData(compressionQuality: compressionQuality) {
                imageData = data
            }
        }
        
        // Create a new UIImage from the compressed data
        if let compressedImage = UIImage(data: imageData) {
            self.image = compressedImage
            calculateAndSetImageSize(compressedImage)
            
            // Print the original and compressed sizes
            let originalSize = originalImage.jpegData(compressionQuality: 1.0)?.count ?? 0
            let compressedSize = imageData.count
            print("Original image size: \(formatFileSize(originalSize))")
            print("Compressed image size: \(formatFileSize(compressedSize))")
            print("Final compression quality: \(compressionQuality)")
            
            return compressedImage

        }
        return originalImage
    }
    
    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let originalSize = image.size
        var newSize = originalSize
        
        if originalSize.width > maxDimension || originalSize.height > maxDimension {
            let widthRatio = maxDimension / originalSize.width
            let heightRatio = maxDimension / originalSize.height
            let scaleFactor = min(widthRatio, heightRatio)
            newSize = CGSize(width: originalSize.width * scaleFactor, height: originalSize.height * scaleFactor)
        }
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    private func calculateAndSetImageSize(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            imageFileSize = "Unable to calculate"
            return
        }
        
        imageFileSize = formatFileSize(imageData.count)
    }
    
    private func formatFileSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
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
