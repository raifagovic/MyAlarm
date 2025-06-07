//
//  MissionCameraView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 7. 6. 2025..
//

import SwiftUI
import AVFoundation

struct MissionCameraView: View {
    @StateObject private var viewModel = MissionCameraViewModel()
    
    let targetObject: String  // e.g., "lemon"

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            // MARK: - Top Right Timer Ring
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                            .frame(width: 60, height: 60)

                        Circle()
                            .trim(from: 0, to: CGFloat(viewModel.progress))
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 60, height: 60)
                            .animation(.linear(duration: 0.2), value: viewModel.progress)

                        Button(action: {
                            viewModel.resetTimer()
                        }) {
                            Text("Reset")
                                .font(.caption)
                        }
                    }
                    .padding()
                }
                Spacer()
            }

            // MARK: - Bottom Info and Capture Button
            VStack(spacing: 12) {
                Spacer()
                Text("Take a picture of: \(targetObject)")
                    .foregroundColor(.white)
                    .font(.headline)

                Button(action: {
                    viewModel.capturePhoto(targetObject: targetObject)
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
        .onReceive(viewModel.timerPublisher) { _ in
            viewModel.updateTimer()
        }
        .alert(isPresented: $viewModel.timeExpired) {
            Alert(title: Text("Time's up!"), message: Text("Alarm will ring again."), dismissButton: .default(Text("OK")) {
                // You can trigger the alarm again here
            })
        }
    }
}
