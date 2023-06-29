//
//  Stacking.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-06-28.
//

import SwiftUI

struct Stacking: View {
    var body: some View {
        ZStack{
            CameraView()
            OverlayingImage()
        }
    }
}

struct Stacking_Previews: PreviewProvider {
    static var previews: some View {
        Stacking()
    }
}
