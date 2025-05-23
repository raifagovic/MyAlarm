//
//  NotificationManager.swift
//  MyAlarm
//
//  Created by Raif Agovic on 6. 4. 2025..
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {} // Prevents creating multiple instances

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ User denied notifications")
            }
        }
    }

    func scheduleAlarmNotification(at date: Date) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Your alarm is ringing!"
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "alarmNotification", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Alarm scheduled for \(date)")
            }
        }
    }
    
    func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        print("🔕 All notifications canceled.")
    }
}

