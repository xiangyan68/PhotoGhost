//
//  ReferenceSelector.swift
//  singlePhoto
//
//  Created by Oliver on 2023-07-05.
//

import SwiftUI

struct ReferenceSelector: View {
    @State var referenceImage: UIImage?
    @State var capturedImage: UIImage?
    
    @State var cameraActive: Bool = false
    
    var body: some View {
        NavigationStack {
            ImagePickerGalleryView(selectedImage: $referenceImage)
                .edgesIgnoringSafeArea(.all)
                .onChange(of: referenceImage) { newValue in
                    if newValue != nil {
                        cameraActive = true
                    }
                }
            
            NavigationLink(
                destination: Stacking(capturedImage: $capturedImage, referenceImage: referenceImage),
                isActive: $cameraActive
            ) {
                 EmptyView()
            }.hidden()
        }
    }
}

struct ReferenceSelector_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceSelector()
    }
}
