//
//  Models.swift
//  MyAlarm
//
//  Created by Raif Agovic on 28. 11. 2024..
//

import SwiftUI

struct Alarm: Identifiable, Codable {
    var id = UUID()
    var time: String
    var isOn: Bool
    var repeatDays: [String] = []
    var label: String = "Alarm"
    var snoozeDuration: Int = 10 
}
