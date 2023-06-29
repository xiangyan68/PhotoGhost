
//  camera.swift
//  singlePhoto
//
//  Created by Xiang Yan on 2023-05-26.

struct camera_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the capture session
        captureSession = AVCaptureSession()

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            // Handle the case where the camera is not available
            return
        }

        // Add the input to the capture session
        captureSession?.addInput(input)

        // Create a preview layer and set its bounds
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.frame = view.layer.bounds

        // Create and add the overlay image view
//        overlayImageView = UIImageView(image: UIImage(named: "overlayImage"))
//        overlayImageView?.contentMode = .scaleAspectFit
//        overlayImageView?.frame = view.bounds
//        view.addSubview(overlayImageView!)
//        view.bringSubviewToFront(overlayImageView!)

        // Add the preview layer to the view's layer hierarchy
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }

        // Start the capture session
        captureSession?.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop the capture session when the view is about to disappear
        captureSession?.stopRunning()
    }
}


import SwiftUI

struct CameraView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let cameraViewController = CameraViewController()
        return cameraViewController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
}
