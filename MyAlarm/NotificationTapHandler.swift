//
//  NotificationTapHandler.swift
//  MyAlarm
//
//  Created by Raif Agovic on 16. 6. 2025..
//

import UserNotifications

class NotificationTapHandler: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    var onTap: ((Alarm) -> Void)?

    init(onTap: ((Alarm) -> Void)? = nil) {
        self.onTap = onTap
        super.init()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 didReceive response: UNNotificationResponse,
                                 withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo

        let label = userInfo["label"] as? String ?? "Alarm"
        let selectedSound = userInfo["selectedSound"] as? String ?? "Default"

        // You can enhance this part later to include other fields if needed
        let alarm = Alarm(
            time: Date(),
            repeatDays: [],
            label: label,
            selectedSound: selectedSound,
            snoozeDuration: 5,
            isOn: true,
            selectedMission: "lemon"
        )

        print("🔔 Notification tapped: launching alarm \(label)")
        onTap?(alarm)

        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // ← SHOW notification while app is foreground
    }
}
