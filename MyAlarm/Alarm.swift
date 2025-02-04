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
    var snoozeDuration: Int
    var isOn: Bool

    init(time: Date, repeatDays: [String], label: String, snoozeDuration: Int, isOn: Bool) {
        self.time = time
        self.label = label
        self.repeatDays = repeatDays
        self.snoozeDuration = snoozeDuration
        self.isOn = isOn
    }
}
