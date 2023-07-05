
import UIKit
import SwiftUI

struct ImagePickerCameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> CameraCoordinator {
        return CameraCoordinator(picker: self)
    }
}

class CameraCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerCameraView
    
    init(picker: ImagePickerCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let capturedImage = info[.originalImage] as? UIImage else { return }
        self.picker.capturedImage = capturedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
    
}
