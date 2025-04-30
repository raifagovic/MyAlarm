//
//  CameraViewModel.swift
//  MyAlarm
//
//  Created by Raif Agovic on 29. 4. 2025..
//

import Foundation
import AVFoundation
import Vision
import CoreML

class CameraViewModel: NSObject, ObservableObject {
    private let model: VNCoreMLModel
    private var onMatch: (() -> Void)?
    private var requiredObject: String = ""
    
    @Published var lastRecognizedObject: String?

    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    override init() {
        // Load the MobileNetV2 model
        guard let visionModel = try? VNCoreMLModel(for: MobileNetV2FP16(configuration: MLModelConfiguration()).model) else {
            fatalError("Failed to load MobileNetV2 model")
        }
        self.model = visionModel
        super.init()
    }

    func startSession(requiredObject: String, onMatch: @escaping () -> Void) {
        self.requiredObject = requiredObject.lowercased()
        self.onMatch = onMatch

        sessionQueue.async {
            self.configureSession()
            self.session.startRunning()
        }
    }

    func stopSession() {
        sessionQueue.async {
            self.session.stopRunning()
        }
    }

    private func configureSession() {
        guard session.inputs.isEmpty else { return }

        session.beginConfiguration()
        session.sessionPreset = .medium

        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else {
            print("Failed to access camera")
            return
        }

        session.addInput(input)

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }

        session.commitConfiguration()
    }
}

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let request = VNCoreMLRequest(model: model) { [weak self] request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let bestResult = results.first else { return }

            DispatchQueue.main.async {
                let identified = bestResult.identifier.lowercased()
                self?.lastRecognizedObject = identified

                if identified.contains(self?.requiredObject ?? "") {
                    self?.onMatch?()
                    self?.onMatch = nil // Prevent multiple triggers
                }
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? handler.perform([request])
    }
}
