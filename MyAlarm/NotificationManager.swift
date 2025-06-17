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

    func scheduleRepeatingAlarmNotifications(startingAt date: Date, label: String) {
        let center = UNUserNotificationCenter.current()
        cancelAllNotifications() // Clear previous ones

        guard let soundURL = Bundle.main.url(forResource: "alarmSound", withExtension: "caf") else {
            print("❌ Alarm sound not found in bundle.")
            return
        }

        let soundName = UNNotificationSoundName("alarmSound.caf")

        for i in 0..<30 {
            let fireDate = Calendar.current.date(byAdding: .minute, value: i, to: date)!
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)

            let content = UNMutableNotificationContent()
            content.title = label.isEmpty ? "Alarm" : label
            content.body = "Your alarm is ringing!"
            content.sound = UNNotificationSound(named: soundName)

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let request = UNNotificationRequest(
                identifier: "alarmNotification_\(i)",
                content: content,
                trigger: trigger
            )

            center.add(request) { error in
                if let error = error {
                    print("❌ Error scheduling notification #\(i): \(error)")
                } else {
                    print("🔔 Scheduled notification #\(i) at \(fireDate)")
                }
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

