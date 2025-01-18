//
//  Models.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct Alarm: Identifiable, Hashable {
    let id = UUID()
    var time: String          // Alarm time (e.g., "08:30").
    var isOn: Bool            // Whether the alarm is active.
    var repeatDays: [String]  // Days the alarm repeats (e.g., ["Mon", "Tue"]).
    var label: String         // Label for the alarm (e.g., "Morning Alarm").
    var snoozeDuration: Int   // Snooze duration in minutes (e.g., 10).
    
    // Initializer with default values for new properties
    init(
        time: String,
        isOn: Bool,
        repeatDays: [String] = [],
        label: String = "Alarm",
        snoozeDuration: Int = 10
    ) {
        self.time = time
        self.isOn = isOn
        self.repeatDays = repeatDays
        self.label = label
        self.snoozeDuration = snoozeDuration
    }
}
