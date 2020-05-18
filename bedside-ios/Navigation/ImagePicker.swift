//
//  ImagePicker.swift
//  bedside-ios
//
//  Created by Andrew Lenox on 5/15/20.
//  Copyright © 2020 Andrew Lenox. All rights reserved.
//

import SwiftUI
import UIKit

import SwiftUI

struct PhotoCaptureView: View {

    @Binding var showImagePicker: Bool
    @Binding var image: Image?
    @Binding var imageUrl : URL?

    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image, imageUrl: $imageUrl)
    }
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var imageUrl: URL?

    init(isShown: Binding<Bool>, image: Binding<Image?>, imageUrl: Binding<URL?>) {
        _isShown = isShown
        _image = image
        _imageUrl = imageUrl
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        image = Image(uiImage: uiImage)
        isShown = false
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)

            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.jpegData(compressionQuality: 0.5)! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            let photoURL = URL.init(fileURLWithPath: localPath!)
            
            
            self.imageUrl = photoURL

        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var imageUrl: URL?

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image, imageUrl: $imageUrl)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .photoLibrary
        } else {
            picker.sourceType = .camera
        }
        return picker
    }

}
