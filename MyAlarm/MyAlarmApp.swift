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
    @StateObject private var notificationDelegate = NotificationTapHandler()

    var body: some Scene {
        WindowGroup {
            if showAlarmRingingView, let alarm = triggeredAlarm {
                AlarmRingingView(alarm: alarm) {
                    self.showAlarmRingingView = false
                }
            } else {
                ContentView()
                    .onAppear {
                        NotificationManager.shared.setupNotificationCategory()
                        NotificationManager.shared.requestNotificationPermission()

                        self.notificationDelegate.onTap = { alarm in
                            self.triggeredAlarm = alarm
                            self.showAlarmRingingView = true
                        }
                        
                        UNUserNotificationCenter.current().delegate = self.notificationDelegate
                    }
            }
        }
        .modelContainer(for: Alarm.self)
    }
}
