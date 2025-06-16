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
            time: Date(),
            repeatDays: [],
            label: label,
            selectedSound: "Default", // Use a real sound name from your app if possible
            snoozeDuration: 5,
            isOn: true,
            selectedMission: "lemon" // or any default you want
        )

        print("🔔 Notification tapped: launching alarm \(label)")
        onTap?(alarm)

        completionHandler()
    }
}
