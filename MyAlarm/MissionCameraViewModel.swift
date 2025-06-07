//
//  MissionCameraViewModel.swift
//  MyAlarm
//
//  Created by Raif Agovic on 7. 6. 2025..
//

import Foundation
import AVFoundation
import Combine

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

        // Use CoreML to check if image matches the `targetObject`
        // If match is found -> dismiss alarm
        // If not -> do nothing or show a message
    }
}
