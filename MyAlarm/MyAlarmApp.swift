//
//  MyAlarmApp.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftData
import SwiftUI
import UserNotifications
import AVFoundation

@main
@MainActor
final class MyAlarmApp: App {
    @State private var showAlarmRingingView = false
    @State private var triggeredAlarm: Alarm?
    
    private var tapHandler: NotificationTapHandler

    var body: some Scene {
        WindowGroup {
            Group {
                if showAlarmRingingView, let alarm = triggeredAlarm {
                    AlarmRingingView(alarm: alarm) {
                        self.showAlarmRingingView = false
                    }
                } else {
                    ContentView()
                }
            }
            .onAppear {
                NotificationManager.shared.requestNotificationPermission()
                prepareAudioSession()

                // Register tap handler
                _ = NotificationTapHandler(onTap: { alarm in
                    self.triggeredAlarm = alarm
                    self.showAlarmRingingView = true
                })
            }
        }
        .modelContainer(for: Alarm.self)
    }

    private func prepareAudioSession() {
        guard let url = Bundle.main.url(forResource: "silent", withExtension: "mp3") else {
            print("🔇 Silent audio file not found")
            return
        }

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)

            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.01
            player.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                player.stop()
            }

            print("✅ Silent audio session initialized")
        } catch {
            print("⚠️ Failed to prepare audio session: \(error)")
        }
    }
}
