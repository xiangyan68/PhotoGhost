//
//  Stacking.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-06-28.
//

import SwiftUI

struct Stacking: View {
    @State private var selectedImage: UIImage?
    var body: some View {
        ZStack{
            ContentView()
        }
    }
}

struct Stacking_Previews: PreviewProvider {
    static var previews: some View {
        Stacking()
    }
}
