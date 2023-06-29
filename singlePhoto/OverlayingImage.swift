//
//  OverlayingImage.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-06-28.
//

import SwiftUI

struct OverlayingImage: View {
    var body: some View {
        Image("IMG_5283")
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
