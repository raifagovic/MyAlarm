//
//  MissionCameraView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 29. 4. 2025..
//

import SwiftUI
import AVFoundation
import Vision

struct MissionCameraView: View {
    let requiredObject: String
    let onSuccess: () -> Void
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        ZStack {
            CameraPreviewView(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Find a \(requiredObject.capitalized)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)

                Spacer()

                if let lastMatch = viewModel.lastRecognizedObject {
                    Text("Detected: \(lastMatch)")
                        .foregroundColor(.white)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            viewModel.startSession(requiredObject: requiredObject, onMatch: onSuccess)
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
}
