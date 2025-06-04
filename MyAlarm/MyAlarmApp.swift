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
struct MyAlarmApp: App {
    init() {
        NotificationManager.shared.requestNotificationPermission()
        prepareAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
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

            // Stop after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                player.stop()
            }

            print("✅ Silent audio session initialized")
        } catch {
            print("⚠️ Failed to prepare audio session: \(error)")
        }
    }
}
