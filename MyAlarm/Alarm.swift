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
    var isOn: Bool
    var label: String
    var repeatDays: [String]
    var snoozeDuration: Int

    init(time: Date, isOn: Bool, repeatDays: [String], label: String, snoozeDuration: Int) {
        self.time = time
        self.isOn = isOn
        self.label = label
        self.repeatDays = repeatDays
        self.snoozeDuration = snoozeDuration
    }
}
