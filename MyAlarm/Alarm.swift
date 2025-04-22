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
    var selectedMission: String

    init(
        time: Date,
        repeatDays: [String],
        label: String,
        selectedSound: String,
        snoozeDuration: Int,
        isOn: Bool,
        selectedMission: String
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
