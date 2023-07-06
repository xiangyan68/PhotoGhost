//
//  Stacking.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-06-28.
//

import SwiftUI

struct Stacking: View {
    @Binding var capturedImage: UIImage?
    var referenceImage: UIImage?
    
    var body: some View {
        ZStack{
            ImagePickerCameraView(capturedImage: $capturedImage)
                .ignoresSafeArea(.all)
                .onChange(of: capturedImage) { _ in
                    if let image = capturedImage {
                        saveImageToAlbum(image)
                    }
                }
            if let image = referenceImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .padding(.bottom, 130)
                    .ignoresSafeArea(.all)
                    .allowsHitTesting(false)
            }
        }
    }
}

struct Stacking_Previews: PreviewProvider {
    static var previews: some View {
        Stacking(capturedImage: Binding.constant(UIImage()))
    }
}


import Photos
func saveImageToAlbum(_ capturedImage: UIImage, albumName: String = "PhotoGhost") {
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
                        let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: capturedImage)
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
                                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: capturedImage)
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
