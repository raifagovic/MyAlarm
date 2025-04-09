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
            // 📱 Small Alarm Banner When Phone is Unlocked
            VStack {
                HStack {
                    Text("⏰") // You can replace this with an icon
                    Text("Alarm")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: stopAlarm) {
                        Text("Stop")
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.black)
                .cornerRadius(12)
                .shadow(radius: 5)
                
                Spacer()
            }
            .padding(.top, 20)
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
        dismiss()
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
