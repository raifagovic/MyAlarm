//
//  MyAlarmApp.swift
//  MyAlarm
//
//  Created by Raif Agovic on 20. 10. 2024..
//

import SwiftData
import SwiftUI
import UserNotifications

@main
@MainActor
final class MyAlarmApp: App {
    @State private var showAlarmRingingView = false
    @State private var triggeredAlarm: Alarm?

    var body: some Scene {
        WindowGroup {
            if showAlarmRingingView, let alarm = triggeredAlarm {
                AlarmRingingView(alarm: alarm) {
                    self.showAlarmRingingView = false
                }
            } else {
                ContentView()
                    .onAppear {
                        NotificationManager.shared.requestNotificationPermission()

                        UNUserNotificationCenter.current().delegate = NotificationTapHandler { alarm in
                            self.triggeredAlarm = alarm
                            self.showAlarmRingingView = true
                        }
                    }
            }
        }
        .modelContainer(for: Alarm.self)
    }
}
