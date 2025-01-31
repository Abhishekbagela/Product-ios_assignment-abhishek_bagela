//
//  ImagePicker.swift
//  Listing-Products
//
//  Created by Abhishek Bagela on 29/01/25.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // Enables cropping
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage { // Use cropped image
                let squareImage = cropToSquare(image: uiImage)
                
                // Check if the image is in JPEG or PNG format
                if let imageData = squareImage.jpegData(compressionQuality: 0.8) ?? squareImage.pngData() {
                    if let finalImage = UIImage(data: imageData) {
                        parent.image = finalImage
                    }
                }
            }
            picker.dismiss(animated: true)
        }
        
        /// Crops an image to a 1:1 square ratio
        private func cropToSquare(image: UIImage) -> UIImage {
            let size = min(image.size.width, image.size.height)
            let xOffset = (image.size.width - size) / 2
            let yOffset = (image.size.height - size) / 2
            let cropRect = CGRect(x: xOffset, y: yOffset, width: size, height: size)
            
            if let cgImage = image.cgImage?.cropping(to: cropRect) {
                return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
            }
            
            return image
        }
    }
}

#Preview {
    ImagePicker(image: .constant(UIImage()))
}
