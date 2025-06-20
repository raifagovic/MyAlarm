//
//  NotificationManager.swift
//  MyAlarm
//
//  Created by Raif Agovic on 6. 4. 2025..
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {} // Singleton

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
    
    func scheduleAlarmNotification(at date: Date, label: String, selectedSound: String) {
        let content = UNMutableNotificationContent()
        content.title = label.isEmpty ? "Alarm" : label
        content.body = "Your alarm is ringing!"

        let soundName = UNNotificationSoundName("\(selectedSound).caf")
        content.sound = UNNotificationSound(named: soundName)

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        content.userInfo = ["label": label, "selectedSound": selectedSound]

        let request = UNNotificationRequest(
            identifier: "alarmNotification_snoozed_\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling snoozed notification: \(error)")
            } else {
                print("🔔 Scheduled snoozed alarm at \(date)")
            }
        }
    }

    func scheduleRepeatingAlarmNotifications(
        startingAt date: Date,
        label: String,
        soundFileName: String = "casio.caf" // Default sound
    ) {
        let center = UNUserNotificationCenter.current()
        cancelAllNotifications()

        let soundName = UNNotificationSoundName(rawValue: "\(soundFileName).caf")

        for i in 0..<30 {
            guard let fireDate = Calendar.current.date(byAdding: .minute, value: i, to: date) else { continue }
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)

            let content = UNMutableNotificationContent()
            content.title = label.isEmpty ? "Alarm" : label
            content.body = "Your alarm is ringing!"
            content.sound = UNNotificationSound(named: soundName)

            content.userInfo = ["label": label, "selectedSound": soundFileName]

            let request = UNNotificationRequest(
                identifier: "alarmNotification_\(i)_\(UUID().uuidString)",
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
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
