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
    var onStop: () -> Void
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPhoneLocked: Bool = false
    @State private var hasShownBanner = false
    @State private var hasStopped = false

    var body: some View {
        Group {
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
                        .padding(.bottom, 20)
                        
                        if alarm.snoozeDuration > 0 {
                            Button(action: snoozeAlarm) {
                                Text("Snooze")
                                    .font(.system(size: 18, weight: .bold))
                                    .frame(width: 200, height: 50)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .padding(.bottom, 100)
                        }
                    }
                }
            } else {
                Color.clear // UIKit banner handles UI
            }
        }
        .task {
            checkPhoneState()
            playSound(named: alarm.selectedSound)

            if !isPhoneLocked && !hasShownBanner {
                hasShownBanner = true
                AlarmBannerManager.shared.showBanner(
                    alarm: alarm,
                    onStop: {
                        AlarmBannerManager.shared.dismissBanner() // ✅ Make sure it's gone
                        stopAlarm()
                    },
                    onSnooze: {
                        AlarmBannerManager.shared.dismissBanner() // ✅ Just to be safe
                        snoozeAlarm()
                    }
                )
            }
        }
        .onDisappear {
            print("Stopping alarm...")
            stopAlarm()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func snoozeAlarm() {
        guard !hasStopped else { return }
        hasStopped = true
        stopAudio()
        
        AlarmBannerManager.shared.dismissBanner()
        
        let snoozedUntil = Calendar.current.date(byAdding: .minute, value: alarm.snoozeDuration, to: Date()) ?? Date()
        
        SnoozedAlarmManager.shared.snoozedUntil = snoozedUntil
        SnoozedAlarmManager.shared.snoozedAlarm = alarm
        
        NotificationManager.shared.scheduleAlarmNotification(at: snoozedUntil)
        print("Alarm snoozed until \(snoozedUntil)")
        onStop()
    }
    
    private func stopAlarm() {
        if !hasStopped {
            hasStopped = true
            stopAudio()
            print("Alarm stopped")
            onStop()
        }
        
        AlarmBannerManager.shared.dismissBanner() // 👈 Always try to dismiss
    }
    
    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    private func playSound(named sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
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

