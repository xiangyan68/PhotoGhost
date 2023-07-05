import SwiftUI
import Photos

struct ContentView: View {
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var sourceType: UIImagePickerController.SourceType = .camera
//    @State private var selectedImage: UIImage?
    @State private var capturedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
//                Image("icon")
//                    .resizable()
//                    .scaledToFit()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 300, height: 300)
                if capturedImage != nil {
                    Image(uiImage: capturedImage!)
                        .resizable()
                        .scaledToFit()
//                        .opacity(0.5)
                } else {
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
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
            .sheet(isPresented: self.$isImagePickerDisplay, onDismiss: saveImageToAlbum) {
                ZStack{
                    ImagePickerCameraView(capturedImage: self.$capturedImage)
                    OverlayingImage()
                }
            }
        }
    }
    func saveImage() {
        guard let image = self.capturedImage else { return }
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges {
                    let albumName = "PhotoGhost" // Replace with your custom album name
//                    var albumAssetPlaceholder: PHObjectPlaceholder?
//                    let albumCreationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
//                    albumAssetPlaceholder = albumCreationRequest.placeholderForCreatedAssetCollection

                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                    let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

                    if let album = fetchResult.firstObject {
                        print("found exsiting")
                        let assetCreationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        guard let assetPlaceholder = assetCreationRequest.placeholderForCreatedAsset else { return }
                        let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                        let enumeration: NSArray = [assetPlaceholder]
                        albumChangeRequest?.addAssets(enumeration)
                    }
                } completionHandler: {success, error in
                    if success{
                        print("success")
                    }
                    if let error = error {
                        print("Error saving image to album: \(error.localizedDescription)")
                    } else {
                        print("Image saved to album.")
                    }
                }
            }
        }
    }
    private func saveImageToAlbum() {
        guard let image = capturedImage else { return }
        
        let albumName = "PhotoGhost"
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                var album: PHAssetCollection?
                
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                
                if let existingAlbum = fetchResult.firstObject {
                    album = existingAlbum
                    print("Album found.")
                    if let album = album {
                        PHPhotoLibrary.shared().performChanges {
                            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                            albumChangeRequest?.addAssets([assetRequest.placeholderForCreatedAsset!] as NSArray)
                        } completionHandler: { success, error in
                            if let error = error {
                                print("Error saving image to album: \(error.localizedDescription)")
                            } else {
                                print("Image saved to album.")
                            }
                        }
                    }
                } else {
                    var albumPlaceholder: PHObjectPlaceholder?
                    
                    PHPhotoLibrary.shared().performChanges {
                        let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                        albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                    } completionHandler: { success, error in
                        if let error = error {
                            print("Error creating album: \(error.localizedDescription)")
                        } else {
                            if let placeholder = albumPlaceholder {
                                album = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil).firstObject
                            }
                            print("Album created.")
                            if let album = album {
                                PHPhotoLibrary.shared().performChanges {
                                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                                    let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                                    albumChangeRequest?.addAssets([assetRequest.placeholderForCreatedAsset!] as NSArray)
                                } completionHandler: { success, error in
                                    if let error = error {
                                        print("Error saving image to album: \(error.localizedDescription)")
                                    } else {
                                        print("Image saved to album.")
                                    }
                                }
                            }
                        }
                    }
                }
                
                
            }
        }
    }
}
