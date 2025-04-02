//
//  AlarmRingingView.swift
//  MyAlarm
//
//  Created by Raif Agovic on 24. 3. 2025..
//

import SwiftUI
import AVFoundation

struct AlarmRingingView: View {
    let alarm: Alarm
    @State private var audioPlayer: AVAudioPlayer?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Alarm Ringing")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
            
            Text(alarm.label.isEmpty ? "Wake Up!" : alarm.label)
                .font(.title2)
                .foregroundColor(.white)
            
            Button("Stop Alarm") {
                stopAlarm()
                dismiss()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            playSound(named: alarm.selectedSound)
        }
        .onDisappear {
            stopAlarm()
        }
    }
    
    private func playSound(named sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop the sound until stopped
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    private func stopAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
