//
//  MissionCameraViewModel.swift
//  MyAlarm
//
//  Created by Raif Agovic on 7. 6. 2025..
//

import Foundation
import AVFoundation
import Combine
import UIKit

class MissionCameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private var output = AVCapturePhotoOutput()
    private var cancellables = Set<AnyCancellable>()

    @Published var progress: Double = 0.0
    @Published var timeExpired = false

    private var timer: Timer?
    private var secondsRemaining: Int = 30
    private let totalSeconds: Int = 30

    var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    override init() {
        super.init()
        configureSession()
    }

    func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        session.beginConfiguration()

        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
    }

    func startSession() {
        if !session.isRunning {
            session.startRunning()
        }
        resetTimer()
    }

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
        timer?.invalidate()
    }

    func updateTimer() {
        guard secondsRemaining > 0 else {
            timer?.invalidate()
            timeExpired = true
            return
        }
        secondsRemaining -= 1
        progress = 1.0 - Double(secondsRemaining) / Double(totalSeconds)
    }

    func resetTimer() {
        secondsRemaining = totalSeconds
        progress = 0.0
    }
    
    func detectObject(in image: UIImage, completion: @escaping (Bool) -> Void) {
        // Use your VNCoreMLRequest + VNImageRequestHandler here
        // Call `completion(true)` if it matches the target object
        // Call `completion(false)` otherwise

        // Example placeholder:
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let result = Bool.random() // replace with real result
            completion(result)
        }
    }

    func capturePhoto(targetObject: String) {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
        // ML analysis will be done in delegate callback
    }
}

// MARK: - Photo Delegate
extension MissionCameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }

        // Run image through ML model (you'll already have this logic)
        detectObject(in: image) { [weak self] matchesTarget in
            guard let self = self else { return }

            if matchesTarget {
                // Call onSuccess on the main thread
                DispatchQueue.main.async {
                    self.onSuccess()
                }
            } else {
                // You can show an error/toast here if needed
                print("❌ Object does not match target")
            }
        }
    }
}
