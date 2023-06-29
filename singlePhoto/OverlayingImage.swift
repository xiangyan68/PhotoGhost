//
//  OverlayingImage.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-06-28.
//

//https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app

import SwiftUI

struct OverlayingImage: View {
    var body: some View {
        Image("IMG_7878")
            .resizable()
            .scaledToFit()
            .opacity(0.5)
    }
}

struct OverlayingImage_Previews: PreviewProvider {
    static var previews: some View {
        OverlayingImage()
    }
}
