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
    @Attribute(.unique) var id: UUID = UUID()
    var time: Date
    var isOn: Bool
    var repeatDays: [String]
    var label: String
    var snoozeDuration: Int

    init(id: UUID, time: Date, isOn: Bool, repeatDays: [String], label: String, snoozeDuration: Int) {
        self.id = id
        self.time = time
        self.isOn = isOn
        self.repeatDays = repeatDays
        self.label = label
        self.snoozeDuration = snoozeDuration
    }
}
