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
    var onStop: () -> Void // 🔹 Closure to notify ContentView
    @State private var isPhoneLocked: Bool = false
    
    var body: some View {
        if isPhoneLocked {
            // 🔒 Full-Screen Alarm When Phone is Locked
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Text(currentTimeString())
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: stopAlarm) {
                        Text("Stop")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 200, height: 60)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }
                    .padding(.bottom, 100)
                }
            }
            .onAppear {
                checkPhoneState()
                playSound(named: alarm.selectedSound)
            }
            .onDisappear {
                stopAlarm()
            }
        } else {
            // 📱 Small Alarm Banner When Phone is Unlocked (Updated)
            VStack {
                HStack {
                    Text("⏰") // Placeholder for icon/logo
                    VStack(alignment: .leading) {
                        Text(alarm.label.isEmpty ? "Alarm" : alarm.label)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: stopAlarm) {
                        Text("Stop")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(.thinMaterial) // Changed to blur effect
                .cornerRadius(12)
                .shadow(radius: 5)
                .edgesIgnoringSafeArea(.top) // Ensures it reaches the very top
                
                Spacer()
            }
            .onAppear {
                checkPhoneState()
                playSound(named: alarm.selectedSound)
            }
            .onDisappear {
                stopAlarm()
            }
        }
    }
    
    private func stopAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
        onStop() // Notify ContentView to remove the banner
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
    
    private func checkPhoneState() {
        let appState = UIApplication.shared.applicationState
        isPhoneLocked = (appState != .active)
    }

    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}
