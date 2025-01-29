//
//  Models.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import Foundation
import SwiftData

@Model
class Alarm {
    @Attribute(.unique) var id: UUID = UUID() // Unique identifier
    var time: Date // Alarm time
    var isOn: Bool // Whether the alarm is active
    var repeatDays: [String] = [] // Repeat days (e.g., ["Monday", "Wednesday"])
    var label: String = "Alarm" // Alarm label
    var snoozeDuration: Int = 10 // Snooze duration in minutes

    init(time: Date, isOn: Bool = true, repeatDays: [String] = [], label: String = "Alarm", snoozeDuration: Int = 10) {
        self.id = UUID()
        self.time = time
        self.isOn = isOn
        self.repeatDays = repeatDays
        self.label = label
        self.snoozeDuration = snoozeDuration
    }
}
