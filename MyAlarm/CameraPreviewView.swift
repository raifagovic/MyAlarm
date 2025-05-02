//
//  CameraPreviewView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 29. 4. 2025..
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        
        if #available(iOS 17.0, *) {
            previewLayer.connection?.videoRotationAngle = 0 // 0° = portrait
        } else {
            previewLayer.connection?.videoOrientation = .portrait
        }

        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No dynamic update needed
    }
}
