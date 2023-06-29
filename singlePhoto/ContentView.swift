import SwiftUI

struct ContentView: View {
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .scaledToFit()
//                        .opacity(0.5)
                } else {
                    Image("icon")
                        .resizable()
                        .scaledToFit()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 300, height: 300)
                }
                Button("Take a photo") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
//                Button("Photos") {
//                    self.sourceType = .photoLibrary
//                    self.isImagePickerDisplay.toggle()
//                }.padding()
            }
            .navigationBarTitle("PhotoGhost")
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ZStack{
                    ImagePickerCameraView()
//                    ImagePickerGalleryView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                   
                    OverlayingImage()
                    
                }
            }
            
        }
    }
}
