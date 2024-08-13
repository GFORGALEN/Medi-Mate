//
//  HomeViewModel.swift
//  Mobile
//
//  Created by Lykheang Taing on 13/08/2024.
//

import Foundation
//
//  HomeViewModel.swift
//  Mobile
//
//  Created by Lykheang Taing on 13/08/2024.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var imageFileSize: String = ""

    func compressAndSetImage(_ originalImage: UIImage) -> UIImage {
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

