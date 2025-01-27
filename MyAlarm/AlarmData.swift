//
//  AlarmData.swift
//  MyAlarm
//
//  Created by Raif Agovic on 21. 1. 2025..
//

import SwiftUI

class AlarmData: ObservableObject {
    @Published var alarms: [Alarm] {
        didSet {
            saveAlarms()
        }
    }

    init() {
        self.alarms = AlarmData.loadAlarms()
    }

    private static func loadAlarms() -> [Alarm] {
        if let data = UserDefaults.standard.data(forKey: "alarms"),
           let decoded = try? JSONDecoder().decode([Alarm].self, from: data) {
            return decoded
        }
        return []
    }

    func saveAlarms() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: "alarms")
        }
    }
    
    // Add or update an alarm in the array
    func saveAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
        } else {
            alarms.append(alarm)
        }
    }
    
    // Delete an alarm
    func deleteAlarm(_ alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
    }
}
