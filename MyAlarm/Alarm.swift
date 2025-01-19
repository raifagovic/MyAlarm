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
    var repeatDays: [String] = [] // Days the alarm repeats (e.g., ["Mon", "Tue"]).
    var label: String = "Alarm"        // Label for the alarm (e.g., "Morning Alarm").
    var snoozeDuration: Int = 10  // Snooze duration in minutes (e.g., 10).
}
