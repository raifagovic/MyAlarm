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
    var time: Date
    var label: String
    var repeatDays: [String]
    var selectedSound: String
    var snoozeDuration: Int
    var isOn: Bool

    // New mission selection stored as a raw string for SwiftData compatibility
    var selectedMission: String

    // Computed property for using the enum in code safely
    var mission: AlarmMission {
        get { AlarmMission(rawValue: selectedMission) ?? .none }
        set { selectedMission = newValue.rawValue }
    }

    init(
        time: Date,
        repeatDays: [String],
        label: String,
        selectedSound: String,
        snoozeDuration: Int,
        isOn: Bool,
        selectedMission: String = AlarmMission.none.rawValue // default to "none"
    ) {
        self.time = time
        self.label = label
        self.repeatDays = repeatDays
        self.selectedSound = selectedSound
        self.snoozeDuration = snoozeDuration
        self.isOn = isOn
        self.selectedMission = selectedMission
    }
}
