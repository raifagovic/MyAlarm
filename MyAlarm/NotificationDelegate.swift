//
//  NotificationDelegate.swift
//  MyAlarm
//
//  Created by Raif Agovic on 15. 4. 2025..
//

import UserNotifications
import UIKit

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    // Called when app is in foreground and notification is delivered
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // Called when user taps an action
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "STOP_ALARM_ACTION" {
            // 🔇 Stop the alarm however your app manages it
            AlarmBannerManager.shared.dismissBanner() // Or other logic
            print("Alarm stopped via notification action")
        }

        completionHandler()
    }
}
