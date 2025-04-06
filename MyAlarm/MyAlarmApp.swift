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
struct MyAlarmApp: App {
    init() {
            NotificationManager.shared.requestNotificationPermission() // Request permission when app starts
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Alarm.self)
    }
}
