//
//  TakePhotoView.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 24/05/2025.
//

import SwiftUI
import UIKit

struct TakePhotoViewRepresentable: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: Coordinator

extension TakePhotoViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: TakePhotoViewRepresentable

        init(_ parent: TakePhotoViewRepresentable) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.isPresented = false
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
            picker.dismiss(animated: true)
        }
    }
}
