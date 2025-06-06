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
    @State private var isPhoneLocked = false
    @State private var hasStopped = false
    @State private var hasShownBanner = false

    var body: some View {
        Group {
            if isPhoneLocked {
                ZStack {
                    Color.black.ignoresSafeArea()

                    VStack {
                        Spacer()

                        // Label at the top (centered)
                        if !alarm.label.trimmingCharacters(in: .whitespaces).isEmpty {
                            Text(alarm.label)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        // Snooze button under the label
                        if alarm.snoozeDuration > 0 {
                            Button(action: snoozeAlarm) {
                                Text("Snooze")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(width: 200, height: 50)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(25)
                            }
                            .padding(.top, 20)
                        }

                        Spacer()

                        // Stop button fixed at the bottom
                        Button(action: stopAlarm) {
                            Text("Stop")
                                .font(.system(size: 24, weight: .bold))
                                .frame(width: 200, height: 60)
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(30)
                        }
                        .padding(.bottom, 40)
                    }
                }
            } else {
                Color.clear
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
                        AlarmBannerManager.shared.dismissBanner()
                        stopAlarm()
                    },
                    onSnooze: {
                        AlarmBannerManager.shared.dismissBanner()
                        snoozeAlarm()
                    }
                )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func snoozeAlarm() {
        guard !hasStopped else { return }
        hasStopped = true
        stopAudio()

        let snoozedUntil = Calendar.current.date(byAdding: .minute, value: alarm.snoozeDuration, to: Date()) ?? Date()
        SnoozedAlarmManager.shared.snoozedUntil = snoozedUntil
        SnoozedAlarmManager.shared.snoozedAlarm = alarm

        NotificationManager.shared.scheduleAlarmNotification(at: snoozedUntil, label: alarm.label)

        print("🔁 Alarm snoozed until \(snoozedUntil)")
        onStop()
    }

    private func stopAlarm() {
        if !hasStopped {
            hasStopped = true
            stopAudio()
            NotificationManager.shared.cancelAllNotifications()
            AlarmBannerManager.shared.dismissBanner()
            onStop()
            print("🛑 Alarm stopped")
        }
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
            print("⚠️ Error playing sound: \(error.localizedDescription)")
        }
    }

    private func checkPhoneState() {
        let appState = UIApplication.shared.applicationState
        isPhoneLocked = (appState != .active)
    }
}
