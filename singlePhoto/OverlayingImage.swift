//
//  OverlayingImage.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-06-28.
//

//https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app

import SwiftUI

struct OverlayingImage: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        VStack{
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
            }
            Button("select reference photo") {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }.padding()
        }
        .navigationBarTitle("PhotoGhost")
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerGalleryView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
    }
}

struct OverlayingImage_Previews: PreviewProvider {
    static var previews: some View {
        OverlayingImage()
    }
}
