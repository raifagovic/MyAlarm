//
//  NotificationTapHandler.swift
//  MyAlarm
//
//  Created by Raif Agovic on 16. 6. 2025..
//

import UserNotifications

class NotificationTapHandler: NSObject, UNUserNotificationCenterDelegate {
    var onTap: ((Alarm) -> Void)?

    init(onTap: ((Alarm) -> Void)? = nil) {
        self.onTap = onTap
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {

        let label = response.notification.request.content.title

        // Create dummy alarm object. You can improve this with decoding real data.
        let alarm = Alarm(
            id: UUID(),
            date: Date(),
            label: label,
            selectedSound: "Default", // Match this to your alarm sounds
            snoozeDuration: 5
        )

        print("🔔 Notification tapped: launching alarm \(label)")
        onTap?(alarm)

        completionHandler()
    }
}
