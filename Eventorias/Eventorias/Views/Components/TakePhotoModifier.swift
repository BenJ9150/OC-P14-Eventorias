//
//  TakePhotoModifier.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 16/06/2025.
//

import SwiftUI
import PhotosUI

struct TakePhotoModifier: ViewModifier {
    @Binding var image: UIImage?
    @Binding var showCamera: Bool
    @Binding var showPhotoPicker: Bool

    @State private var photoPicker: PhotosPickerItem?

    func body(content: Content) -> some View {
        content
            /// Picture from library
            .photosPicker(
                isPresented: $showPhotoPicker,
                selection: $photoPicker,
                matching: .any(of: [.images, .screenshots, .panoramas])
            )
            .onChange(of: photoPicker) { _ in
                Task {
                    if let data = try? await photoPicker?.loadTransferable(type: Data.self) {
                        withAnimation(UIAccessibility.isReduceMotionEnabled ? nil : .default) {
                            image = UIImage(data: data)
                        }
                    }
                }
            }
            /// New picture from camera
            .sheet(isPresented: $showCamera) {
                TakePhotoViewRepresentable(
                    image: $image,
                    isPresented: $showCamera
                )
            }
    }
}

extension View {

    func takePhoto(
        image: Binding<UIImage?>,
        showCamera: Binding<Bool>,
        showPhotoPicker: Binding<Bool>
    ) -> some View {
        modifier(TakePhotoModifier(
            image: image,
            showCamera: showCamera,
            showPhotoPicker: showPhotoPicker
        ))
    }
}

// MARK: Take Photo View

import UIKit

fileprivate struct TakePhotoViewRepresentable: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

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
