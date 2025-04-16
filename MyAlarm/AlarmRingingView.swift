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
    var onStop: () -> Void
    @State private var isPhoneLocked: Bool = false
    @State private var hasShownBanner = false

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
                // 📱 No UI here – banner is shown using UIKit
                Color.clear
            }
        }
        .onAppear {
            checkPhoneState()
            playSound(named: alarm.selectedSound)

            if !isPhoneLocked && !hasShownBanner {
                hasShownBanner = true
                AlarmBannerManager.shared.showBanner(
                    alarm: alarm,
                    onStop: {
                        stopAlarm()
                    },
                    onSnooze: {
                        snoozeAlarm()
                    }
                )
            }
        }
        .onDisappear {
            stopAlarm()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func snoozeAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
        AlarmBannerManager.shared.dismissBanner()

        // Reschedule alarm
        let newDate = Calendar.current.date(byAdding: .minute, value: alarm.snoozeDuration, to: Date()) ?? Date()
        NotificationManager.shared.scheduleAlarmNotification(at: newDate)

        print("Alarm snoozed until \(newDate)")
        onStop()
    }
    
    private func stopAlarm() {
        audioPlayer?.stop()
        audioPlayer = nil
        onStop()
        AlarmBannerManager.shared.dismissBanner()
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
